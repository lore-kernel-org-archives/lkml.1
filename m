Return-Path: <linux-kernel-owner+w=401wt.eu-S1761106AbYEPTCT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761106AbYEPTCT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 May 2008 15:02:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752436AbYEPTCL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 16 May 2008 15:02:11 -0400
Received: from outbound-mail-34.bluehost.com ([69.89.18.154]:33373 "HELO
	outbound-mail-34.bluehost.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1754439AbYEPTCK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 May 2008 15:02:10 -0400
From: Jesse Barnes <jbarnes@virtuousgeek.org>
To: Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: Re: [PATCH][PCI]: Introduce pci_find_capability_cached and make MSI use it
Date: Fri, 16 May 2008 12:01:48 -0700
User-Agent: KMail/1.9.9
Cc: Matthew Wilcox <matthew@wil.cx>, linux-kernel@vger.kernel.org,
       linux-pci@vger.kernel.org, linux-rt-users@vger.kernel.org
References: <20080515160426.GD14846@ghostprotocols.net> <200805161044.34938.jbarnes@virtuousgeek.org> <20080516183356.GA7307@ghostprotocols.net>
In-Reply-To: <20080516183356.GA7307@ghostprotocols.net>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200805161201.48644.jbarnes@virtuousgeek.org>
X-Identified-User: {642:box128.bluehost.com:virtuous:virtuousgeek.org} {sentby:smtp auth 75.111.27.49 authed with jbarnes@virtuousgeek.org}
DomainKey-Status: no signature
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday, May 16, 2008 11:33 am Arnaldo Carvalho de Melo wrote:
> > There are a few other common cap checks, but I don't think they compare
> > to MSI in terms of latency sensitivity (though I didn't audit all the
> > CAP_ID_EXP checks, there are quite a few of those).
> >
> > Since we know MSI is a problem, let's just go with fixing that for now. 
> > If we find that other caps are also causing problems we can revisit
> > caching all of them; the patch is simple enough.
>
> Do you want me to submit another patch or can you cook up one?

I can hack it up, probably not until Monday though (I'll be out of town this 
weekend).

Jesse
