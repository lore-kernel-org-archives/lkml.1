Return-Path: <linux-kernel-owner+w=401wt.eu-S937456AbYD1UAu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S937456AbYD1UAu (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Apr 2008 16:00:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S935355AbYD1UAW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 28 Apr 2008 16:00:22 -0400
Received: from an-out-0708.google.com ([209.85.132.246]:2251 "EHLO
	an-out-0708.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S935249AbYD1UAU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Apr 2008 16:00:20 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:mime-version:content-type:content-transfer-encoding:content-disposition;
        b=fY55vJ+qUGk+hYcmwJUjydCIjkTjRkKzS3pbGkXJTw4BU5OxypvCVl+wK9sC7I+0JuEvMDH8UgdNUVnYny7UkRbnSaOigJszyykc4kPNXtxjrMLj5L6r2ldkHWqxY3imldL0C59iqlBNCOb2sGSoGPxLsX2+iv++3AUnjZpAD/I=
Message-ID: <dd18b0c30804281300y23fb939eyf8a3aaf17d11e0cd@mail.gmail.com>
Date: Mon, 28 Apr 2008 20:00:18 +0000
From: "Justin Mattock" <justinmattock@gmail.com>
To: LKML <linux-kernel@vger.kernel.org>
Subject: videodev2.h
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

With compiling uvcvidoe for the macbook pro, I encounted some errors,
about the definition already defined, to resolve this issue:
I ended up taking out in = include/linux/videodev2.h:

/*#define V4L2_CTRL_CLASS_CAMERA 0x009a0000 */	/* Camera class controls */

/*#define V4L2_CID_POWER_LINE_FREQUENCY	(V4L2_CID_BASE+24)
*enum v4l2_power_line_frequency {
*	V4L2_CID_POWER_LINE_FREQUENCY_DISABLED	= 0,
*	V4L2_CID_POWER_LINE_FREQUENCY_50HZ	= 1,
*	V4L2_CID_POWER_LINE_FREQUENCY_60HZ	= 2,
};*/

/*#define V4L2_CID_EXPOSURE_AUTO			(V4L2_CID_CAMERA_CLASS_BASE+1)
*enum  v4l2_exposure_auto_type {
*	V4L2_EXPOSURE_AUTO = 0,
*	V4L2_EXPOSURE_MANUAL = 1,
*	V4L2_EXPOSURE_SHUTTER_PRIORITY = 2,
*	V4L2_EXPOSURE_APERTURE_PRIORITY = 3
};*/

For the module to install properly. "I think uvcvideo gets confused
with having two videodev.h, and videodev2.h files, but could be wrong"
located in:
include/linux/*
usr/include/linux/*
regards;
-- 
Justin P. Mattock
