Return-Path: <linux-kernel-owner+w=401wt.eu-S1757492AbYARKu7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757492AbYARKu7 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Jan 2008 05:50:59 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751361AbYARKut
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 18 Jan 2008 05:50:49 -0500
Received: from py-out-1112.google.com ([64.233.166.176]:12083 "EHLO
	py-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750853AbYARKus (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Jan 2008 05:50:48 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:in-reply-to:references:content-type:date:message-id:mime-version:x-mailer:content-transfer-encoding;
        b=iCkjEztpMMIusaNWnkb27DLwbDuTwUQhuaLOatVdEu44IyX3Pd6YGAgz6me8Q4HRcUPBo7lXDzB8EcQHBt1plvUpG5SmmXKuhW85qtB/rlplmjH0o0z94gwAFJ/FSvR58RXhVWNqMosIcpPuvewmiQ1inKnViR3GNxu1hq2zW0M=
Subject: Re: [2.6.24 patch] x86: allow 64bit setting in Kconfig
From: Harvey Harrison <harvey.harrison@gmail.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: Adrian Bunk <bunk@kernel.org>, Sam Ravnborg <sam@ravnborg.org>,
       tglx@linutronix.de, mingo@redhat.com, hpa@zytor.com,
       linux-kernel@vger.kernel.org
In-Reply-To: <20080118104401.GA8785@elte.hu>
References: <20080117214301.GA28233@does.not.exist>
	 <20080118104401.GA8785@elte.hu>
Content-Type: text/plain
Date: Fri, 18 Jan 2008 02:50:48 -0800
Message-Id: <1200653448.5724.135.camel@brick>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Fri, 2008-01-18 at 11:44 +0100, Ingo Molnar wrote:
> * Adrian Bunk <bunk@kernel.org> wrote:
> 
> >  # Select 32 or 64 bit
> >  config 64BIT
> > -	bool "64-bit kernel" if ARCH = "x86"
> > +	bool "64-bit kernel"
> >  	default ARCH = "x86_64"
> >  	help
> >  	  Say yes to build a 64-bit kernel - formerly known as x86_64
> 
> thx, i've added this to x86.git.

Style question, would the following be preferred?

config 64BIT
	def_bool ARCH = "x86_64"
	prompt "64-bit kernel"
	help...


Cheers,

Harvey

