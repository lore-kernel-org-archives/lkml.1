Return-Path: <linux-kernel-owner+w=401wt.eu-S1757550AbYEWTIZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757550AbYEWTIZ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 May 2008 15:08:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754311AbYEWTIS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 23 May 2008 15:08:18 -0400
Received: from smtp-vbr15.xs4all.nl ([194.109.24.35]:3497 "EHLO
	smtp-vbr15.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754277AbYEWTIS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 May 2008 15:08:18 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: video4linux-list@redhat.com
Subject: Re: [PATCH] video4linux: Push down the BKL
Date: Fri, 23 May 2008 21:05:30 +0200
User-Agent: KMail/1.9.7
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>, linux-kernel@vger.kernel.org,
       Mauro Carvalho Chehab <mchehab@infradead.org>
References: <20080522223700.2f103a14@core>
In-Reply-To: <20080522223700.2f103a14@core>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200805232105.30577.hverkuil@xs4all.nl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 22 May 2008 23:37:00 Alan Cox wrote:
> For most drivers the generic ioctl handler does the work and we
> update it and it becomes the unlocked_ioctl method. Older drivers use
> the usercopy method so we make it do the work. Finally there are a
> few special cases.
>
> Signed-off-by: Alan Cox <alan@redhat.com>

Here is my Ack for the ivtv/cx18 parts of this patch:

Acked-by: Hans Verkuil <hverkuil@xs4all.nl>

Regards,

	Hans
