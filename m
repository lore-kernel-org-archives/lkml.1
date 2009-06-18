Return-Path: <linux-kernel-owner+w=401wt.eu-S1755190AbZFRVFS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755190AbZFRVFS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Jun 2009 17:05:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753002AbZFRVFH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 18 Jun 2009 17:05:07 -0400
Received: from mail-fx0-f212.google.com ([209.85.220.212]:64099 "EHLO
	mail-fx0-f212.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753443AbZFRVFG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Jun 2009 17:05:06 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=message-id:date:from:user-agent:x-accept-language:mime-version:to
         :cc:subject:references:in-reply-to:x-enigmail-version:content-type
         :content-transfer-encoding;
        b=GFGMGQScNmARIpE5A2NbIhhOtKvph4EnmhpSsjDKXpXvq0Sx4w1GLJsKFFx+vpXnNH
         m8TowDldzCH0xMaSIt2J91C1iCsCheO2sE+i2uGbQ38uma+QoDIsU2tovTTDVN5PAcOB
         GxCoaAABwT2T0wAw5CTxBUGlhisKKlNHxVVpw=
Message-ID: <4A3AAC01.7050805@googlemail.com>
Date: Thu, 18 Jun 2009 23:05:05 +0200
From: Michael Riepe <michael.riepe@googlemail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686 (x86_64); en-US; rv:1.7.13) Gecko/20060417
X-Accept-Language: de-de, de, en-us, en
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: linux-kernel@vger.kernel.org, Rudolf Marek <r.marek@assembler.cz>,
       lm-sensors@lm-sensors.org
Subject: Re: [PATCH] Enable coretemp driver on Intel Atom
References: <49E7C34A.60007@googlemail.com> <20090618121326.42ab9c2f.akpm@linux-foundation.org>
In-Reply-To: <20090618121326.42ab9c2f.akpm@linux-foundation.org>
X-Enigmail-Version: 0.91.0.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

Andrew Morton wrote:

> I'm not 100% sure what to do about this patch.  I'm inclined to merge
> it, even though you think it might be giving the wrong numbers,
> because then someone might fix it.

That was the basic idea :-)

> otoh, if giving the wrong numbers leads to people's machines needlessly
> shutting down or something like that, then that's not so good.

I don't think that that will happen. Core temperatures on my 330 are
lower than those reported by the other sensors (core 0/1: 27/35 °C on an
idle system - hardly alarming in my opinion).

-- 
Michael "Tired" Riepe <michael.riepe@googlemail.com>
X-Tired: Each morning I get up I die a little
