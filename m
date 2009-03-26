Return-Path: <linux-kernel-owner+w=401wt.eu-S1757491AbZCZIib@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757491AbZCZIib (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Mar 2009 04:38:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756351AbZCZIfI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Mar 2009 04:35:08 -0400
Received: from mail-fx0-f158.google.com ([209.85.220.158]:58646 "EHLO
	mail-fx0-f158.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756290AbZCZIfE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Mar 2009 04:35:04 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:reply-to:mail-followup-to
         :references:mime-version:content-type:content-disposition
         :in-reply-to:user-agent;
        b=V+6/yaasjdPjKEVUC7popw7jDq1MZhslj/NDJY75HvQK8rH/PnpRabPJTfpBzhQuSA
         CHBJc2FXVxYzV8ETw/YBrqf1AXvTSbKTAuJOosQAbp1YNwVcsuoeWfijk3u54TFjSO5k
         FWrBTMlx5gHGy6CG113ooW1VIHypiq41hWFVE=
Date: Thu, 26 Mar 2009 09:34:56 +0100
From: Borislav Petkov <petkovbb@googlemail.com>
To: Tejun Heo <tj@kernel.org>
Cc: bzolnier@gmail.com, linux-kernel@vger.kernel.org, axboe@kernel.dk,
       linux-ide@vger.kernel.org
Subject: Re: [PATCH 11/14] ide-cd: don't abuse rq->buffer
Message-ID: <20090326083456.GB32155@liondog.tnic>
Reply-To: petkovbb@gmail.com
Mail-Followup-To: petkovbb@gmail.com, Tejun Heo <tj@kernel.org>,
	bzolnier@gmail.com, linux-kernel@vger.kernel.org, axboe@kernel.dk,
	linux-ide@vger.kernel.org
References: <1237910776-10983-1-git-send-email-tj@kernel.org> <1237910776-10983-12-git-send-email-tj@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <1237910776-10983-12-git-send-email-tj@kernel.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Mar 25, 2009 at 01:06:13AM +0900, Tejun Heo wrote:
> Impact: rq->buffer usage cleanup
> 
> ide-cd uses rq->buffer to carry pointer to the original request when
> issuing REQUEST_SENSE.  Use rq->special instead.
> 
> Signed-off-by: Tejun Heo <tj@kernel.org>
> Cc: Jens Axboe <axboe@kernel.dk>

Acked-by: Borislav Petkov <petkovbb@gmail.com>

-- 
Regards/Gruss,
    Boris.
