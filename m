Return-Path: <linux-kernel-owner+w=401wt.eu-S1754008AbXIVUre@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754008AbXIVUre (ORCPT <rfc822;w@1wt.eu>);
	Sat, 22 Sep 2007 16:47:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751658AbXIVUr0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 22 Sep 2007 16:47:26 -0400
Received: from wa-out-1112.google.com ([209.85.146.177]:4735 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751275AbXIVUrZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 22 Sep 2007 16:47:25 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=XpLfAdzf/WTDm76oUhTEoQNQvcM6eNHQO6lXESBGiJnIU+laHaAxbJ1v8IwidQbU7Uq+sDDEdY1Bw2G9Wv+rqygYeCIqgUDBxEBYXKubOvlneej8lcOtbFQiHbIMlys+aUwCdTR8nSAeO+Vf/uKA2jTTnjqrlpFzWrr1RyHaKC8=
Message-ID: <86802c440709221347n5d72da55rb894cca428d627b3@mail.gmail.com>
Date: Sat, 22 Sep 2007 13:47:24 -0700
From: "Yinghai Lu" <yhlu.kernel@gmail.com>
To: "Robert Hancock" <hancockr@shaw.ca>
Subject: Re: [PATCH] [9/50] i386: validate against ACPI motherboard resources
Cc: "Andi Kleen" <ak@suse.de>, rajesh.shah@intel.com, jbarnes@virtuousgeek.org,
       greg@kroah.com, patches@x86-64.org, linux-kernel@vger.kernel.org
In-Reply-To: <46F542A4.9080207@shaw.ca>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <200709221231.836138000@suse.de>
	 <20070921223207.7BBE71479D@wotan.suse.de>
	 <86802c440709212349l3d968d1bgdc89e7c7415b54da@mail.gmail.com>
	 <46F542A4.9080207@shaw.ca>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 9/22/07, Robert Hancock <hancockr@shaw.ca> wrote:
> Yinghai Lu wrote:
> > No!
> >
> > MMCONFIG will not work with acpi=off any more.
>
> I don't think this is unreasonable. The ACPI MCFG table is how we are
> supposed to learn about the area in the first place. If we can't get the
> table location via an approved mechanism, and can't validate it doesn't
> overlap with another memory reservation or something, I really don't
> think we should be using it.
>
> I don't think it's much of an issue anyway - the chances that somebody
> will want to run without ACPI on a system with MCFG are pretty low given
> that you'll end up losing a bunch of functionality (not least of which
> is multi-cores).

with acpi=off, that we do lose some features including acpi hotplug
and power management feature...
but we don't lose anything about numa ( multi-cores...) and
bus-numa... (we get these info from NB pci conf for AMD rev C, rev E,
rev F, and Fam 10 opteron)...

Finally we lose bugs introduced by ACPI code ...

YH
