Return-Path: <linux-kernel-owner+w=401wt.eu-S1757605AbYA2LXA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757605AbYA2LXA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Jan 2008 06:23:00 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754238AbYA2LWx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 29 Jan 2008 06:22:53 -0500
Received: from pentafluge.infradead.org ([213.146.154.40]:44428 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753285AbYA2LWw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Jan 2008 06:22:52 -0500
Date: Tue, 29 Jan 2008 09:22:33 -0200
From: Mauro Carvalho Chehab <mchehab@infradead.org>
To: Hans Verkuil <hverkuil@xs4all.nl>
Cc: v4l-dvb-maintainer@linuxtv.org, Adrian Bunk <bunk@kernel.org>,
       Ian Armstrong <ian@iarmst.demon.co.uk>, linux-kernel@vger.kernel.org,
       ivtv-devel@ivtvdriver.org
Subject: Re: [v4l-dvb-maintainer] [2.6 patch] ivtv-yuv.c: make 3 functions
 static
Message-ID: <20080129092233.4c203ac4@gaivota>
In-Reply-To: <200801282350.22243.hverkuil@xs4all.nl>
References: <20080128221053.GS8767@does.not.exist>
	<200801282350.22243.hverkuil@xs4all.nl>
X-Mailer: Claws Mail 3.2.0 (GTK+ 2.12.1; x86_64-mandriva-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <mchehab@infradead.org> by pentafluge.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 28 Jan 2008 23:50:22 +0100
Hans Verkuil <hverkuil@xs4all.nl> wrote:

> On Monday 28 January 2008 23:10:53 Adrian Bunk wrote:
> > This patch makes the following needlessly global functions static:
> > - ivtv_yuv_next_free()
> > - ivtv_yuv_setup_frame()
> > - ivtv_yuv_udma_frame()
> >
> > Signed-off-by: Adrian Bunk <bunk@kernel.org>
> 
> Signed-off-by: Hans Verkuil <hverkuil@xs4all.nl>
> 
> Mauro, feel free to merge. Alternatively, I can add it to my v4l-dvb 
> tree which has some additional patches (will post a PULL request for 
> that in the next few days).

I'll merge it right now. It is easier for me to run a script importing the
entire Adrian patch series ;)

Since I've received the patch directly from Adrian, I've changed your SOB to
reviewed-by.


Cheers,
Mauro
