Return-Path: <linux-kernel-owner+w=401wt.eu-S1754208AbYKRPpP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754208AbYKRPpP (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Nov 2008 10:45:15 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752165AbYKRPpB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 18 Nov 2008 10:45:01 -0500
Received: from smtp113.mail.mud.yahoo.com ([209.191.84.66]:45668 "HELO
	smtp113.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751681AbYKRPpB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Nov 2008 10:45:01 -0500
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com.au;
  h=Received:X-YMail-OSG:X-Yahoo-Newman-Property:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id;
  b=UrW78mn8sMVdZpPWGtzRjrR8TG6rYfvK9Uqzf82bHcK1i8cg9EFd0OdaaKIoZSZH5DquTf1338hoc0wa8BuWdc5neRJCa1i9H6ZuEvq+9s94PJRLcboZNVllvZXMdnYZrTGINFE0uZHDrYXUmlJdSmWgqCbn5XI02xI+s0uBfa0=  ;
X-YMail-OSG: aUXQgDAVM1mOlZcZ_aci2YUtFsKmWU6K_PsHfAf_TkdzVnHo3nNJ1IrmdUdvKVE6HclFf2RdZnq9_JKQYMcm5T7cz5pCHSHj4g_4rhRvPPbA9G6jpKNMNgU1mG.qaywBPi3m
X-Yahoo-Newman-Property: ymail-3
From: Nick Piggin <nickpiggin@yahoo.com.au>
To: Kumar Gala <kumar.gala@freescale.com>
Subject: Re: questions on how x86 uses IPI for tlb invalidates
Date: Wed, 19 Nov 2008 02:44:51 +1100
User-Agent: KMail/1.9.5
Cc: linux-kernel Kernel <linux-kernel@vger.kernel.org>
References: <6F2B69F5-7312-49AB-B86A-6AE6B753095B@freescale.com>
In-Reply-To: <6F2B69F5-7312-49AB-B86A-6AE6B753095B@freescale.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200811190244.52013.nickpiggin@yahoo.com.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 19 November 2008 02:20, Kumar Gala wrote:
> I'm looking at adding some code into powerpc for doing tlb invalidate
> broadcasts via IPI and am looking at the x86 code as a model.  I was
> wondering how the x86 code ensures we aren't interrupted in the
> process of doing something like flush_tlb_page().

What's the problem with being interrupted?
