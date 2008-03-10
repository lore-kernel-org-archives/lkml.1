Return-Path: <linux-kernel-owner+w=401wt.eu-S1757475AbYCJXOX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757475AbYCJXOX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Mar 2008 19:14:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755138AbYCJXNG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 10 Mar 2008 19:13:06 -0400
Received: from fg-out-1718.google.com ([72.14.220.154]:53468 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754151AbYCJXNC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Mar 2008 19:13:02 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:subject:date:user-agent:cc:references:in-reply-to:mime-version:content-disposition:message-id:content-type:content-transfer-encoding;
        b=QGyhan4gXnO+LT4eZ1SY/LzU19ciHPM+QNcOgzA2J7lMfXd35ae9UVPB5/1d4R+Bog3a3xd4j6ocKqy0tmgMIKEwRVU05+cLRzWPJP/m9FuggyW3N580CsndJcJEx7Z3FY1xhMUd3DANKrgKcNNdAuoEFwaN4Ay2vPYUh/9uCq8=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: Borislav Petkov <petkovbb@googlemail.com>
Subject: Re: [PATCH 3/4] ide-tape remove pipeline speed/control calculations
Date: Tue, 11 Mar 2008 00:25:42 +0100
User-Agent: KMail/1.9.9
Cc: linux-kernel@vger.kernel.org, linux-ide@vger.kernel.org,
       Borislav Petkov <petkovbb@gmail.com>
References: <1205082632-3418-1-git-send-email-petkovbb@gmail.com> <1205082632-3418-4-git-send-email-petkovbb@gmail.com>
In-Reply-To: <1205082632-3418-4-git-send-email-petkovbb@gmail.com>
MIME-Version: 1.0
Content-Disposition: inline
Message-Id: <200803110025.42437.bzolnier@gmail.com>
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sunday 09 March 2008, Borislav Petkov wrote:
> Pipeline handling calculations in idetape_calculate_speeds() can
> go since they do not have any effect on other functionality besides:
> 
> 1. info is only being exported through /proc as a read-only item
> (controlled_pipeline_head_speed, uncontrolled_pipeline_head_speed)
> 
> 2. used in idetape_restart_speed_control() which, in turn, is unrelated to
> other code
> 
> 3. used only for pipeline frames number accounting (tape->pipeline_head),
> also unused elsewhere.
> 
> 4.some variables are:
>         only written to: tape->buffer_head;
>         unused: tape->tape_head, tape->last_tape_head
> 
> Signed-off-by: Borislav Petkov <petkovbb@gmail.com>

applied
