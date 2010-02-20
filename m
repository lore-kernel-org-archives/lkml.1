Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756708Ab0BTV6R (ORCPT <rfc822;w@1wt.eu>);
	Sat, 20 Feb 2010 16:58:17 -0500
Received: from mail-fx0-f219.google.com ([209.85.220.219]:47674 "EHLO
	mail-fx0-f219.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756507Ab0BTV6Q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 20 Feb 2010 16:58:16 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=from:to:subject:date:user-agent:cc:references:in-reply-to
         :mime-version:content-type:content-transfer-encoding
         :content-disposition:message-id;
        b=nwUsLPQFjmEZNfnLuAZLciK8ELdLTxoKWMWa7stPorOFqr4lo9WfDPdxFiIDRekvp7
         e3CYZQx67t+oFM/X29RAfznQdtdTyFmQGuh5s+dmas5wqvyN0C3lBev6GGfXP7ioB1RF
         X8YDWIOMlwPBtp6DH+1oHreMuBhzThNUTdBUw=
From: Denys Vlasenko <vda.linux@googlemail.com>
To: Andi Kleen <andi@firstfloor.org>
Subject: Re: [PATCH 00/24] Rename kernel's magic sections for compatibility with -ffunction-sections -fdata-sections
Date: Sat, 20 Feb 2010 22:58:07 +0100
User-Agent: KMail/1.8.2
Cc: Michal Marek <mmarek@suse.cz>, Sam Ravnborg <sam@ravnborg.org>,
       Haavard Skinnemoen <hskinnemoen@atmel.com>,
       David Howells <dhowells@redhat.com>, linux-kernel@vger.kernel.org,
       Bjorn Wesen <bjornw@axis.com>, Tim Bird <tim.bird@am.sony.com>,
       Tim Abbott <tabbott@ksplice.com>, Anders Kaseorg <andersk@ksplice.com>,
       Waseem Daher <wdaher@ksplice.com>,
       Rusty Russell <rusty@rustcorp.com.au>,
       Stephen Rothwell <sfr@canb.auug.org.au>,
       "H. Peter Anvin" <hpa@zytor.com>
References: <1266624237-22372-1-git-send-email-vda.linux@googlemail.com> <20100220092253.GC11287@basil.fritz.box>
In-Reply-To: <20100220092253.GC11287@basil.fritz.box>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <201002202258.07991.vda.linux@googlemail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Andi,

On Saturday 20 February 2010 10:22, Andi Kleen wrote:
> On Sat, Feb 20, 2010 at 01:03:33AM +0100, Denys Vlasenko wrote:
> > Hi Michal, Sam, folks,
> > Here is a new version of the -ffunction-sections -fdata-sections patch
> > series based on current Linus tree.
> Denys,
> 
> Not read all your patches. But I had recently the problem
> that I need a generic way to check for a symbol being
> inside the kernel image (text or data).

I'm not sure I understood the problem.

> There wasn't 
> a common symbol that worked for both XIP ARM and normal
> architectures. Is this something addressed by your patchkit?

Most likely not.
-- 
vda
