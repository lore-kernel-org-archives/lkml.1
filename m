Return-Path: <linux-kernel-owner+w=401wt.eu-S1754868AbYC2RGx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754868AbYC2RGx (ORCPT <rfc822;w@1wt.eu>);
	Sat, 29 Mar 2008 13:06:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753104AbYC2RGp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 29 Mar 2008 13:06:45 -0400
Received: from terminus.zytor.com ([198.137.202.10]:33936 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752936AbYC2RGp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 29 Mar 2008 13:06:45 -0400
Message-ID: <47EE7704.9030301@zytor.com>
Date: Sat, 29 Mar 2008 10:06:12 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.12 (X11/20080226)
MIME-Version: 1.0
To: Paul Jackson <pj@sgi.com>
CC: "Huang, Ying" <ying.huang@intel.com>, andi@firstfloor.org,
       mingo@redhat.com, tglx@linutronix.de, linux-kernel@vger.kernel.org
Subject: Re: [PATCH -mm 2/4] x86_64 boot: Add linked list of struct setup_data
References: <1206601748.3067.22.camel@caritas-dev.intel.com>	<20080327063307.ac323913.pj@sgi.com>	<1206670181.13404.7.camel@caritas-dev.intel.com> <20080329012423.0c1d693e.pj@sgi.com>
In-Reply-To: <20080329012423.0c1d693e.pj@sgi.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Paul Jackson wrote:
> Huang wrote:
>> The setup_data will not only be used for E820 extension.
> 
> I'm still unsure of your meaning.
> 
> Are you saying that 'setup_data' is not used in your current patch set?
> 
> Are you also saying that 'setup_data' will be used in the future?
> 

They will be used for other things in the future.  EDD extension is one 
we already know about -- the current EDD code doesn't carry as much 
information as we want.

	-hpa
