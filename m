Return-Path: <linux-kernel-owner+w=401wt.eu-S1763820AbZD3PFe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763820AbZD3PFe (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Apr 2009 11:05:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762943AbZD3PFP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 30 Apr 2009 11:05:15 -0400
Received: from mail1.sea5.speakeasy.net ([69.17.117.3]:35124 "EHLO
	mail1.sea5.speakeasy.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760190AbZD3PFN convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Apr 2009 11:05:13 -0400
Date: Thu, 30 Apr 2009 08:05:12 -0700 (PDT)
From: Trent Piepho <xyzzy@speakeasy.org>
X-X-Sender: xyzzy@shell2.speakeasy.net
To: =?UTF-8?B?TsOpbWV0aCBNw6FydG9u?= <nm127@freemail.hu>
cc: Mauro Carvalho Chehab <mchehab@infradead.org>, linux-media@vger.kernel.org,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] v4l2: fill the reserved fields of VIDIOC_REQBUFS ioctl
In-Reply-To: <49F8A325.7060303@freemail.hu>
Message-ID: <Pine.LNX.4.58.0904300803410.7837@shell2.speakeasy.net>
References: <49F8A325.7060303@freemail.hu>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=X-UNKNOWN
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 29 Apr 2009, [UTF-8] Németh Márton wrote:
> The parameter of VIDIOC_REQBUFS is a pointer to struct v4l2_requestbuffers.
> This structure has reserved fields which has to be filled with zeros
> according to the V4L2 API specification, revision 0.24 [1].

As I read the spec, the reserved fields can be used for input from user
space if the buffer is of type V4L2_BUF_TYPE_PRIVATE or higher.
