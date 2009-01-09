Return-Path: <linux-kernel-owner+w=401wt.eu-S1756406AbZAIXMl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756406AbZAIXMl (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Jan 2009 18:12:41 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753269AbZAIXMa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 9 Jan 2009 18:12:30 -0500
Received: from outbound-mail-306.bluehost.com ([67.222.53.252]:51341 "HELO
	outbound-mail-306.bluehost.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1752899AbZAIXM3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Jan 2009 18:12:29 -0500
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws; s=default; d=virtuousgeek.org;
	h=Received:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id:X-Identified-User;
	b=lpKGRW+fkdLOPGs9a7ACLEbDbeTa1jmU83EZUEN8XglqsuYEPQpwm5em4W0ZNTqGsz5QAT4qqxDF0OsbkRtF65RgCVAFiawm+CTGENM8GgK68t3BZxr0nz0qSc85OUeO;
From: Jesse Barnes <jbarnes@virtuousgeek.org>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Subject: Re: [PATCH 1/8] PCI PCIe portdrv: Remove root ports MSI quirk
Date: Fri, 9 Jan 2009 15:12:26 -0800
User-Agent: KMail/1.9.10
Cc: Linux PCI <linux-pci@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>
References: <200901042346.42723.rjw@sisk.pl> <200901042348.22012.rjw@sisk.pl>
In-Reply-To: <200901042348.22012.rjw@sisk.pl>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-2"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200901091512.27206.jbarnes@virtuousgeek.org>
X-Identified-User: {642:box128.bluehost.com:virtuous:virtuousgeek.org} {sentby:smtp auth 75.111.27.49 authed with jbarnes@virtuousgeek.org}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sunday, January 4, 2009 2:48 pm Rafael J. Wysocki wrote:
> From: Rafael J. Wysocki <rjw@sisk.pl>
>
> The PCI Express port driver contains a quirk that prevents root
> ports from using MSI, but there is no explanation for it and the
> PCI Express specification clearly allows root ports to use MSI.

Weird.  This *looks* fine, but presumably it was added for some reason?  
Unfortunately the git logs don't go back that far.  I'll ping some of our 
chipset guys to see if there were early issues with this or something; at the 
very least we could probably make the quirk a bit narrower in scope.

-- 
Jesse Barnes, Intel Open Source Technology Center
