Return-Path: <linux-kernel-owner+w=401wt.eu-S1758440AbYILWDy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758440AbYILWDy (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Sep 2008 18:03:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753167AbYILWDq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 12 Sep 2008 18:03:46 -0400
Received: from yw-out-2324.google.com ([74.125.46.31]:60318 "EHLO
	yw-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751717AbYILWDp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Sep 2008 18:03:45 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=A60qOJl2X4l/44ZU7qwJnLjHbD0BPrsRXhMwCF/M+ypOq8aYzkVFHBNv+3mN1w0xHS
         w+rVX7feczMkT6LE9CzqyeU/1TNIQolUEEtz7K4C4KjpJD+uA3oaaGQqsiR3cYLe0DUL
         Q+aV8tHJeia+00pJRrUJr4498nVPUJBZL3aF8=
Message-ID: <457e13650809121503o8fea405kce9002495a65953@mail.gmail.com>
Date: Sat, 13 Sep 2008 01:03:44 +0300
From: "Oleksandr Natalenko" <pfactum@gmail.com>
To: linux-kernel@vger.kernel.org
Subject: Re: REGRESSION: Sound's decreasing when headphones are plugged
In-Reply-To: <457e13650809121314k44ba4978xb1413f856f951bfb@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <457e13650809121314k44ba4978xb1413f856f951bfb@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

It seems that automatic identifying in ALSA is broken or changed. When
I added line

options snd-hda-intel model=dell-3stack

to /etc/modprobe.d/alsa-base

everything began to work fine.
