Return-Path: <linux-kernel-owner+w=401wt.eu-S1754156AbXLIWNU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754156AbXLIWNU (ORCPT <rfc822;w@1wt.eu>);
	Sun, 9 Dec 2007 17:13:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751754AbXLIWNL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 9 Dec 2007 17:13:11 -0500
Received: from web52903.mail.re2.yahoo.com ([206.190.49.13]:39375 "HELO
	web52903.mail.re2.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751556AbXLIWNK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 9 Dec 2007 17:13:10 -0500
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com;
  h=X-YMail-OSG:Received:Date:From:Subject:To:Cc:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Message-ID;
  b=uqYY8i8NTfmqM00zAm6PSOyN+HAA6sLPemi4kxSrcOT2RzENusEuYrzP0Ex95iJKwewaUuvCjaAaf1utjMFZ0QMMFDNjULWLxRRAV/SIsa1CVvyi6Iec0s6vrZLi78GUOJfyc1BGItFPKylzWzmb2BjIbsl1F0tUUWHGQluhWuI=;
X-YMail-OSG: V4T2mlcVM1nXr.f9rE6OveaAAwWvjabGElKsqCv2oVtriz9F9oBMg_VE4AyE9VARFR9UkRJiV17g1ibYzg58LKwO_RG0YTTouTO6fHYlYapv71FrAz9_doY9GO_Czw--
Date: Sun, 9 Dec 2007 22:13:09 +0000 (GMT)
From: Chris Rankin <rankincj@yahoo.com>
Subject: Re: [2.6.23.9] hostap_plx locks up PC when reading PCI I/O memory
To: Stefano Brivio <stefano.brivio@polimi.it>
Cc: Dan Williams <dcbw@redhat.com>, Andrew Morton <akpm@linux-foundation.org>,
       linux-kernel@vger.kernel.org, linux-wireless@vger.kernel.org
In-Reply-To: <20071209230652.7156fe17@morte>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Message-ID: <248113.29149.qm@web52903.mail.re2.yahoo.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--- Stefano Brivio <stefano.brivio@polimi.it> wrote:
> Not a fix, but if you load the module with ignore_cis = 1, it should work.

Well, if the I/O memory mapping is broken then wouldn't that just move the problem down to the
next attempt to access it?

Cheers,
Chris



      __________________________________________________________
Sent from Yahoo! Mail - a smarter inbox http://uk.mail.yahoo.com

