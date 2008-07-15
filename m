Return-Path: <linux-kernel-owner+w=401wt.eu-S1760613AbYGONFl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760613AbYGONFl (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jul 2008 09:05:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756602AbYGONFd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 Jul 2008 09:05:33 -0400
Received: from ti-out-0910.google.com ([209.85.142.184]:16506 "EHLO
	ti-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756507AbYGONFc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jul 2008 09:05:32 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=kDYhKQSctFCgvzfoXLFVBpO0yW0RF/fXnvRJugKV9WhqV0bHFTvWOzbC4t4kvfw/TB
         Fq9pZjfDcIUo8bKlL7co+AqiWinUNI5XAM6VpotwGK/Rix/SBFYTqSDCwOVYcnpxkBw8
         MS+V7FWvhO8/aK3Y5+jAG75rhkL6RH1kk7QRM=
Message-ID: <3aa654a40807150605r6d6206delcd903aac58f6291d@mail.gmail.com>
Date: Tue, 15 Jul 2008 06:05:30 -0700
From: "Avuton Olrich" <avuton@gmail.com>
To: "Martin Michlmayr" <tbm@cyrius.com>
Subject: Re: s2disk: system powers up again after power off
Cc: linux-kernel@vger.kernel.org, "Rafael J. Wysocki" <rjw@sisk.pl>
In-Reply-To: <20080715124733.GA4111@deprecation.cyrius.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20080715124733.GA4111@deprecation.cyrius.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 15, 2008 at 5:47 AM, Martin Michlmayr <tbm@cyrius.com> wrote:
> When I use s2disk to suspend my HP 2510p notebook, it writes
> everything to disk, and powers off... but after 2-3 seconds it often
> powers on again.  This doesn't happen all the time but quite
> frequently (definitely in the majority of cases).
>
> I believe I've never seen this when I use "halt" to power off the
> machine (but I don't use halt very often).
>
> Any idea?

Ugh, this happens here too, this started occuring before 2.6.25 but
every time I try to bisect it takes hours and I end up screwing up
somewhere along the way, so I haven't had time to bisect this
correctly.
-- 
avuton
--
 "I've got a fever. And the only prescription is more cowbell." --
Christopher Walken
