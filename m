Return-Path: <linux-kernel-owner+w=401wt.eu-S1755283AbZCVRZX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755283AbZCVRZX (ORCPT <rfc822;w@1wt.eu>);
	Sun, 22 Mar 2009 13:25:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754639AbZCVRZH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 22 Mar 2009 13:25:07 -0400
Received: from qw-out-2122.google.com ([74.125.92.26]:47264 "EHLO
	qw-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750879AbZCVRZG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 22 Mar 2009 13:25:06 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:in-reply-to:references:content-type:date
         :message-id:mime-version:x-mailer:content-transfer-encoding;
        b=EPnCKJ8AlcoWxNY14OEyCwEC0dTuq+RmwzrjhSF/cFC6NmMn2deNshPZukZbXhRb3P
         sAtBJnvPp9QVvhiUw8vwT1cccNc1Y3zI4R2GSz0QHP/a0nauVU82R43g9/SBu770TCjg
         z10+hR2QkV51qlDCD54rsCYHrAjb3AiouCxvY=
Subject: Re: [PATCH 2/4] tracing: add ring_buffer_event_discard() to ring
	buffer
From: Tom Zanussi <tzanussi@gmail.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: linux-kernel <linux-kernel@vger.kernel.org>,
       Steven Rostedt <rostedt@goodmis.org>,
       =?ISO-8859-1?Q?Fr=E9d=E9ric?= Weisbecker <fweisbec@gmail.com>
In-Reply-To: <20090322141435.GA29751@elte.hu>
References: <1237710649.7703.47.camel@charm-linux>
	 <20090322141435.GA29751@elte.hu>
Content-Type: text/plain
Date: Sun, 22 Mar 2009 12:25:01 -0500
Message-Id: <1237742701.7703.53.camel@charm-linux>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.0 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Sun, 2009-03-22 at 15:14 +0100, Ingo Molnar wrote:
> * Tom Zanussi <tzanussi@gmail.com> wrote:
> 
> > This patch overloads RINGBUF_TYPE_PADDING to provide a way to discard
> > events from the ring buffer, for the event-filtering mechanism
> > introduced in a subsequent patch.
> > 
> > I did the initial version but thanks to Steven Rostedt for adding the
> > parts that actually made it work. ;-)
> 
> I suspect it's signed-off-by both of you?
> 

Oops, yeah, here's mine:

Signed-off-by: Tom Zanussi <tzanussi@gmail.com>


> 	Ingo

