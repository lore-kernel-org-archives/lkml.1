Return-Path: <linux-kernel-owner+w=401wt.eu-S1754078AbYKSTqT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754078AbYKSTqT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Nov 2008 14:46:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752305AbYKSTqJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 19 Nov 2008 14:46:09 -0500
Received: from acsinet12.oracle.com ([141.146.126.234]:43454 "EHLO
	acsinet12.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751761AbYKSTqH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Nov 2008 14:46:07 -0500
Message-ID: <49246CF0.9010105@oracle.com>
Date: Wed, 19 Nov 2008 11:45:52 -0800
From: Randy Dunlap <randy.dunlap@oracle.com>
Organization: Oracle Linux Engineering
User-Agent: Thunderbird 2.0.0.6 (X11/20070801)
MIME-Version: 1.0
To: Ben Hutchings <bhutchings@solarflare.com>
CC: David Woodhouse <dwmw2@infradead.org>,
       Stephen Rothwell <sfr@canb.auug.org.au>, linux-next@vger.kernel.org,
       LKML <linux-kernel@vger.kernel.org>, linux-net-drivers@solarflare.com
Subject: Re: linux-next: Tree for November 19 (mtd build error)
References: <20081119175917.7d21cf77.sfr@canb.auug.org.au>	 <20081119105321.477e618a.randy.dunlap@oracle.com>	 <1227121104.27728.618.camel@macbook.infradead.org>	 <492463A1.3000306@oracle.com>  <1227122287.3052.7.camel@achroite>	 <1227122696.27728.625.camel@macbook.infradead.org> <1227123805.3052.10.camel@achroite>
In-Reply-To: <1227123805.3052.10.camel@achroite>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Source-IP: acsmt703.oracle.com [141.146.40.81]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A01020A.49246CF3.0100:SCFSTAT928724,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ben Hutchings wrote:
> On Wed, 2008-11-19 at 19:24 +0000, David Woodhouse wrote:
>> On Wed, 2008-11-19 at 19:18 +0000, Ben Hutchings wrote:
>>> So does the dependency need to be something like
>>> "depends on SFC && MTD && !(SFC=y && MTD=m)"?
>> If it's a separate driver, perhaps it's sufficient just to make it a
>> tristate and make it depend on SFC && MTD?
> 
> It's not a separate driver.

and it already depends on SFC && MTD.  Weird that it fails like this.

-- 
~Randy
