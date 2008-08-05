Return-Path: <linux-kernel-owner+w=401wt.eu-S1756193AbYHEEoe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756193AbYHEEoe (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Aug 2008 00:44:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752638AbYHEEo1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 5 Aug 2008 00:44:27 -0400
Received: from smtp105.mail.mud.yahoo.com ([209.191.85.215]:48290 "HELO
	smtp105.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751338AbYHEEo0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Aug 2008 00:44:26 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com.au;
  h=Received:X-YMail-OSG:X-Yahoo-Newman-Property:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id;
  b=E+xaWbrQ2C/hu3sC5iGrTW7oxYmxdVmTpVdbd+7WpGrpGftNnm4qH3c9mgm25gS+uNLTO6WwqisK23KrGQceiyf5BGKzUnUHHpDbkukh5fsF6/2cBbHwy+YAh6NHHiRDmbU36lgsoU8hmmSnirrHLcFMXyDXGN8Byv25+wQlDeM=  ;
X-YMail-OSG: GJ5dCzYVM1ll3MomX220Wr1eIGVK4r47egLUdJ_x4WXWjX4_A4x5egD9lXMeFIB00g2jmQA6lLRWNL_HonuAE7cr3RsLmr8s1m.ARD.k6mMjLXiwNrMb81xFM8r_VTB8vo4-
X-Yahoo-Newman-Property: ymail-3
From: Nick Piggin <nickpiggin@yahoo.com.au>
To: Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: Switching TestSetPageLocked to trylock_page
Date: Tue, 5 Aug 2008 14:44:19 +1000
User-Agent: KMail/1.9.5
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
References: <200807311726.51816.nickpiggin@yahoo.com.au> <20080804205754.b05c8aa9.akpm@linux-foundation.org> <alpine.LFD.1.10.0808042131590.3299@nehalem.linux-foundation.org>
In-Reply-To: <alpine.LFD.1.10.0808042131590.3299@nehalem.linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200808051444.19738.nickpiggin@yahoo.com.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 05 August 2008 14:32, Linus Torvalds wrote:
> On Mon, 4 Aug 2008, Andrew Morton wrote:
> > Would prefer either that we hold off until after 2.6.27 is released or
> > just do it now.
>
> Ok, I took that as an ack and just applied it.

Buffer trylock too? Pretty please ;)
