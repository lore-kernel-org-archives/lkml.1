Return-Path: <linux-kernel-owner+w=401wt.eu-S1755245AbYG2Bht@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755245AbYG2Bht (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Jul 2008 21:37:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752596AbYG2Bhf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 28 Jul 2008 21:37:35 -0400
Received: from smtp112.mail.mud.yahoo.com ([209.191.84.65]:33888 "HELO
	smtp112.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1754986AbYG2Bhc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Jul 2008 21:37:32 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com.au;
  h=Received:X-YMail-OSG:X-Yahoo-Newman-Property:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id;
  b=Umji3d2leAXTN3WrC1OvZoHAJMnISIMi7RL+W1EBrvg6HysvKM8FmMYEsA+DwwCc8FpITvMiQijmXoqbUkJGvKXs+4hBDPI/IKuiQMhvpFDa3u+cpyGWDY0Xf55Ec0MewIA7/3M59UfAQbPwzXdG2bEJJZ912eRuNONu4cgAOQA=  ;
X-YMail-OSG: DO8TOHoVM1kMsTbun3bMjKxoZwNvwNHd2qM7KKzKG13UjfFrDyUuFMlx9I.qtDWZ1RPJSQJ3pL2GNPQBjrTciNKyfTQEPPuOtrHxz8Hp2.WN4UEgESPQmys3VAgmg2wr3JQ-
X-Yahoo-Newman-Property: ymail-3
From: Nick Piggin <nickpiggin@yahoo.com.au>
To: Linus Torvalds <torvalds@linux-foundation.org>, benh@kernel.crashing.org
Subject: Re: [PATCH] x86: do not overrun page table ranges in gup
Date: Tue, 29 Jul 2008 11:37:19 +1000
User-Agent: KMail/1.9.5
Cc: Johannes Weiner <hannes@saeurebad.de>,
       Alexey Dobriyan <adobriyan@gmail.com>, akpm@linuxfoundation.org,
       torvalds@linuxfoundation.org, npiggin@suse.de,
       linux-kernel@vger.kernel.org
References: <20080728184947.GA5041@martell.zuzino.mipt.ru> <alpine.LFD.1.10.0807281721200.3486@nehalem.linux-foundation.org> <alpine.LFD.1.10.0807281737480.3486@nehalem.linux-foundation.org>
In-Reply-To: <alpine.LFD.1.10.0807281737480.3486@nehalem.linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200807291137.20259.nickpiggin@yahoo.com.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 29 July 2008 10:39, Linus Torvalds wrote:
> On Mon, 28 Jul 2008, Linus Torvalds wrote:
> > So no, the right fix would be to align 'start' first, which means that
> > everything else (including 'end') will be page-aligned. Aligning just one
> > or the other is very very wrong.
>
> Does this work?
>
> Not pretty, but it stands _some_ chance of being correct.

No, that's not particularly ugly and I think the fix is good. Thank you
everyone involved in the thread.

Acked-by: Nick Piggin <npiggin@suse.de>
