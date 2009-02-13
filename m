Return-Path: <linux-kernel-owner+w=401wt.eu-S1757822AbZBMUk6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757822AbZBMUk6 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Feb 2009 15:40:58 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752138AbZBMUkr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 13 Feb 2009 15:40:47 -0500
Received: from outbound-mail-133.bluehost.com ([67.222.39.23]:46670 "HELO
	outbound-mail-133.bluehost.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751899AbZBMUkq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Feb 2009 15:40:46 -0500
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws; s=default; d=virtuousgeek.org;
	h=Received:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id:X-Identified-User;
	b=a6MLvP/Po67vnqyf9YWihGeYHS38XSWOs3MzG/koyWr5prRxwkldtLYAbE1JwiY/yQTNJaf0aqg1Mo3cIO+Jdwq8h/8RELutX9BMRE7ravCF9ZWFixel/CJZ0w3pLzhm;
From: Jesse Barnes <jbarnes@virtuousgeek.org>
To: Ingo Molnar <mingo@elte.hu>
Subject: Re: [RFC] [PATCH] PCI mmconfig without ACPI
Date: Fri, 13 Feb 2009 12:40:41 -0800
User-Agent: KMail/1.9.10
Cc: Ed Swierk <eswierk@aristanetworks.com>, tglx@linutronix.de,
       mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       lenb@kernel.org, linux-acpi@vger.kernel.org, linux-pci@vger.kernel.org
References: <1233766786.16414.26.camel@localhost.localdomain> <20090204181738.GA16174@elte.hu>
In-Reply-To: <20090204181738.GA16174@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200902131240.42943.jbarnes@virtuousgeek.org>
X-Identified-User: {642:box128.bluehost.com:virtuous:virtuousgeek.org} {sentby:smtp auth 75.111.27.49 authed with jbarnes@virtuousgeek.org}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday, February 4, 2009 10:17 am Ingo Molnar wrote:
> But again, nice patch and it would be nice to see this concept hit
> mainline.

Yeah, concept seems fine, and the cleanups you suggested sound good (splitting 
the files would make things clearer, and some of that stuff probably belongs 
in the ACPI or PNP core anyway).

My only concern is that enabling mmconfig w/o a reservation (as might happen 
if ACPI was disabled) may cause problems since it could overlap with other 
space.  That was one of the issues we ran into when enabling it in the first 
place...  But we've worked around it so far so I'm happy to give it a spin 
for the next cycle.

Thanks,
-- 
Jesse Barnes, Intel Open Source Technology Center
