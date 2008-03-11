Return-Path: <linux-kernel-owner+w=401wt.eu-S1751766AbYCKXK4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751766AbYCKXK4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Mar 2008 19:10:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750987AbYCKXKq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 11 Mar 2008 19:10:46 -0400
Received: from wf-out-1314.google.com ([209.85.200.175]:2967 "EHLO
	wf-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750939AbYCKXKp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Mar 2008 19:10:45 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=fbJh5FOvNukmA7q07ImyeBDgOcTnroJekm5QwugVw66j/198O03c6s8Add9jwbvWkz22t7zbO6MWNYtdUrTM98jktyXPqbMjwGcYCXLUr3bTwOPYpg3n6U2imnOFqlYRJuXTX3BTRj1XFBrJKS0Vsr1eNRRmzdoJf2RTPMqR2PA=
Message-ID: <7c86c4470803111610s4a017835s8998d72e44acad3f@mail.gmail.com>
Date: Tue, 11 Mar 2008 16:10:41 -0700
From: "stephane eranian" <eranian@googlemail.com>
To: "Greg KH" <gregkh@suse.de>
Subject: Re: [PATCH 3/3] perfmon x86 infra(take 2): add AMD Northbridge PCI Id
Cc: linux-kernel@vger.kernel.org, "Robert Richter" <robert.richter@amd.com>
In-Reply-To: <20080311171216.GB26410@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <7c86c4470803071305x6b575dxa9f7b0588abfd4b@mail.gmail.com>
	 <7c86c4470803110950p54349250pbe29d4122912a2f6@mail.gmail.com>
	 <20080311171216.GB26410@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Greg,


On Tue, Mar 11, 2008 at 10:12 AM, Greg KH <gregkh@suse.de> wrote:
> On Tue, Mar 11, 2008 at 09:50:36AM -0700, stephane eranian wrote:
>  > Greg,
>  >
>  > Ingo suggested I send ou the following patch which adds a PCI ID
>  > for AMD Barcelona Northbridge. This is used by the perfmon initialization
>  > code on this platform.
>  >
>  > Please apply to your tree.
>
>  We are trying to not add pci ids that are only used in one place within
>  the kernel.  Why can't the perfomon init code just add this value to
>  their code?
>
I thought you would want a central place where all PCI ids are defined.
But if you prefer not, then so be it. I'll put it into the perfmon code.

>  Or make this part of the perfmon patch itself, if you really must have
>  it.  No need to add it to the kernel if there are no in-tree users,
>  right?
>
I am starting to push perfmon patches upstream. So you should expect
patches which  *currently* have no in-tree users. You have to start from
somewhere, right?
