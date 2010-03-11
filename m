Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932319Ab0CKNN4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Mar 2010 08:13:56 -0500
Received: from bombadil.infradead.org ([18.85.46.34]:38307 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932235Ab0CKNNz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Mar 2010 08:13:55 -0500
Subject: Re: [PATCH] Group scheduler statistics in one struct
From: Peter Zijlstra <peterz@infradead.org>
To: Lucas De Marchi <lucas.de.marchi@gmail.com>
Cc: mingo@elte.hu, linux-kernel@vger.kernel.org
In-Reply-To: <1268275065-18542-1-git-send-email-lucas.de.marchi@gmail.com>
References: <193b0f821003101829u29adb233tbf807fd50bd3b5eb@mail.gmail.com>
	 <1268275065-18542-1-git-send-email-lucas.de.marchi@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 11 Mar 2010 14:13:52 +0100
Message-ID: <1268313232.5037.33.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2010-03-10 at 23:37 -0300, Lucas De Marchi wrote:
> Put all statistic fields of sched_entity in one struct, sched_statistics,
> and embed it into sched_entity.
> 
> This change allows to memset the sched_statistics to 0 when needed (for
> instance when forking), avoiding bugs of non initialized fields.
> 
> Signed-off-by: Lucas De Marchi <lucas.de.marchi@gmail.com> 

Thanks!

