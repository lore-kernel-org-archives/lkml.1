Return-Path: <linux-kernel-owner+w=401wt.eu-S933566AbXCPKFd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933566AbXCPKFd (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Mar 2007 06:05:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933575AbXCPKFd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 16 Mar 2007 06:05:33 -0400
Received: from nf-out-0910.google.com ([64.233.182.191]:7539 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933566AbXCPKFc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Mar 2007 06:05:32 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=LcstWLG4qafXOl+PtNiBwRaIPRzdY3SwT/SFx1owsYfNbSViTfIfoNlRPKtOYAv2y69WaOU/HLFkrKKV7EicWxnmih4JiwAkz6I1zDgMYDpp1O38FVM/Ed83HrvoxKwb+FU75raEYZrastBXWnRHcID9FUq4JvLRLoDQUfty/LY=
Message-ID: <aec7e5c30703160305p5d91af41h147e3a6c2687bcd9@mail.gmail.com>
Date: Fri, 16 Mar 2007 19:05:30 +0900
From: "Magnus Damm" <magnus.damm@gmail.com>
To: vgoyal@in.ibm.com
Subject: Re: [Fastboot] [PATCH 1/1] Allow i386 crash kernels to handle x86_64 dumps
Cc: "Ian Campbell" <Ian.Campbell@xensource.com>, Horms <horms@verge.net.au>,
       fastboot@lists.osdl.org, linux-kernel@vger.kernel.org
In-Reply-To: <20070316093542.GB5642@in.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20070315050754.GB22329@verge.net.au>
	 <1173961378.8591.63.camel@localhost.localdomain>
	 <20070315132616.GH6766@in.ibm.com>
	 <20070315234807.GB10861@verge.net.au>
	 <aec7e5c30703151940x7447abbey80cb6e47250cca58@mail.gmail.com>
	 <1174030097.28658.37.camel@localhost.localdomain>
	 <aec7e5c30703160059u108d984dt6bfb831603a887c5@mail.gmail.com>
	 <1174035001.28658.61.camel@localhost.localdomain>
	 <aec7e5c30703160220i3e8a03cbh431622975acbe72d@mail.gmail.com>
	 <20070316093542.GB5642@in.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 3/16/07, Vivek Goyal <vgoyal@in.ibm.com> wrote:
> Got a question. When running 32bit dom0 on 64bit hypervisor, which
> kexec-tools elf loader will kick in? 32bit or 64bit? Looks like in this
> case 64bit one. But shouldn't it be 32bit as 32bit OS is running and we
> must be using the kexec-tools binary compiled for 32bit OS? And if 32bit
> loader kicks in we will not be passing any acpi parameters.

There is no check to see if the hypervisor is 32 or 64 bits present
today. So the 32-bit version of kexec-tools will support loading
images like any other 32-bit kexec-tools.

Thanks,

/ magnus
