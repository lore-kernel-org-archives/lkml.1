Return-Path: <linux-kernel-owner+w=401wt.eu-S1755113AbYHTW2s@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755113AbYHTW2s (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Aug 2008 18:28:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752680AbYHTW2j
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 20 Aug 2008 18:28:39 -0400
Received: from nf-out-0910.google.com ([64.233.182.185]:37026 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752468AbYHTW2i (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Aug 2008 18:28:38 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=dLKlUGncaT29IEWtpRp7m7mDFgmvc0YOVTB/l0Y8px1nu0+uR5brwuDJpEC6CIsado
         ZeKWwy8nqkJblJfKvaNFlE6pL8AkfQ8ctf0S8Y7QM7igLDG0SepYfKKgjSK830F7QlPR
         48fLKuJyl2WCcugFwGvWQaK3TEeWe2vWyhZ5I=
Message-ID: <7b97a12b0808201528o5bab7840w1226d1faadb2c924@mail.gmail.com>
Date: Wed, 20 Aug 2008 19:28:37 -0300
From: "Gary Shi" <garyu.shi@gmail.com>
To: "Jeremy Fitzhardinge" <jeremy@goop.org>
Subject: Re: [PATCH] sysrq: freeze other CPUs during sysrq-t
Cc: linux-kernel@vger.kernel.org
In-Reply-To: <48A70DF4.5040901@goop.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <7b97a12b0808151738s7f1a166es51c5f26bd25285c0@mail.gmail.com>
	 <48A70DF4.5040901@goop.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 8/16/08, Jeremy Fitzhardinge <jeremy@goop.org> wrote:
> Why not use stop_machine()?

Just know about  stop_machine() from your reply. Thanx. But after
checking its src, I feel its too demanding to fit sysrq-t use; e.g.,
when other cpus got deadlocked on some spin locks with preempt
disabled, then the kernel threads of stopmachine won't get a chance to
run on other cpus.

We would expect one or more cpus response only to irqs, when we try to
collect sysrq data; most of the  time, only when the systems hang for
whatever reasons does the sysrq data need to be collected, right?

--gys
