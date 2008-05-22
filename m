Return-Path: <linux-kernel-owner+w=401wt.eu-S1757229AbYEVSko@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757229AbYEVSko (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 May 2008 14:40:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754143AbYEVSkd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 22 May 2008 14:40:33 -0400
Received: from e34.co.us.ibm.com ([32.97.110.152]:55499 "EHLO
	e34.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753767AbYEVSkc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 May 2008 14:40:32 -0400
Subject: Re: [RFC][Patch 1/4]integrity: TPM internel kernel interface
From: Mimi Zohar <zohar@linux.vnet.ibm.com>
To: Pavel Machek <pavel@suse.cz>
Cc: linux-kernel@vger.kernel.org, safford@watson.ibm.com,
       serue@linux.vnet.ibm.com, sailer@watson.ibm.com, zohar@us.ibm.com,
       Stephen Smalley <sds@tycho.nsa.gov>,
       CaseySchaufler <casey@schaufler-ca.com>
In-Reply-To: <20080522150516.GB25721@elf.ucw.cz>
References: <1211385256.20922.25.camel@localhost.localdomain>
	 <20080522150516.GB25721@elf.ucw.cz>
Content-Type: text/plain
Date: Thu, 22 May 2008 14:39:53 -0400
Message-Id: <1211481593.4867.9.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.3 (2.12.3-4.fc8) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Thu, 2008-05-22 at 17:05 +0200, Pavel Machek wrote:
> On Wed 2008-05-21 11:54:16, Mimi Zohar wrote:
> > This is a request for comments for a redesign of the integrity patches.
> > This patchset contains 4 patches.
> > 	Patch 1/4 integrity: TPM internal kernel interface
> > 	Patch 2/4 integrity: special fs magic
> > 	Patch 3/4 integrity: Linux Integrity Module(LIM)
> > 	Patch 4/4 integrity: IMA as an integrity service provider
> >  
> > Resubmitting integrity-tpm-internal-kernel-interface.patch, which
> > was previously Signed-off-by Kylene Hall.
> > 
> > Adds the following support: 
> > - internal kernel interface to transmit TPM commands
> > - reading a pcr value
> > - extending a pcr value
> > - lookup the tpm_chip for given chip number and type
> > 
> > Signed-off-by: Mimi Zohar <zohar@us.ibm.com>
> 
> >  /*
> > - * Returns max number of jiffies to wait
> > + * tpm_calc_ordinal_duration - returns max number of jiffies to wait
> >   */
> > -unsigned long tpm_calc_ordinal_duration(struct tpm_chip *chip,
> > -					   u32 ordinal)
> > +unsigned long tpm_calc_ordinal_duration(struct tpm_chip *chip, u32 ordinal)
> 
> Please don't mix real changes and cleanups... and lots of your changes
> are just cleanups.
> 
> > @@ -544,7 +549,7 @@ duration:
> >  	data[TPM_CAP_SUBCAP_IDX] = TPM_CAP_PROP_TIS_DURATION;
> >  
> >  	rc = transmit_cmd(chip, data, sizeof(data),
> > -			"attempting to determine the durations");
> > +			  "attempting to determine the durations");
> >  	if (rc)
> >  		return;
> >
> 
> ...like this.
> 									Pavel

Ok.  Will separate the changes, from the scripts/Lindent cleanups. 

Mimi

