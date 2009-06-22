Return-Path: <linux-kernel-owner+w=401wt.eu-S1756552AbZFVOGV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756552AbZFVOGV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Jun 2009 10:06:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752411AbZFVOGN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 22 Jun 2009 10:06:13 -0400
Received: from mga02.intel.com ([134.134.136.20]:27177 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752259AbZFVOGN convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Jun 2009 10:06:13 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.42,268,1243839600"; 
   d="scan'208";a="526768185"
From: "Guy, Wey-Yi W" <wey-yi.w.guy@intel.com>
To: Greg KH <greg@kroah.com>, Arjan van de Ven <arjan@infradead.org>
CC: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Date: Mon, 22 Jun 2009 07:06:14 -0700
Subject: RE: iwlwifi: show qos AC parameters
Thread-Topic: iwlwifi: show qos AC parameters
Thread-Index: Acny5L1i2LtDPH0JQiexFtMzr35mVwAXcbNg
Message-ID: <E9954878DD1FB34FAE5187FB88C58A3557072BE9@orsmsx506.amr.corp.intel.com>
References: <200906152114.n5FLEDT3015406@hera.kernel.org>
 <20090621110727.74d95b28@infradead.org> <20090622024838.GB18153@kroah.com>
In-Reply-To: <20090622024838.GB18153@kroah.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Oh ok.
I will submit the patch to fix this.

Wey-Yi Guy
Intel Corporation
2111 N.E. 25th Avenue  M/S JF3-308                 
Hillsboro OR 97124-5961
USA
Work Phone: 503-264-6023 (OR)
Cell Phone: 503-329-8410
Email: wey-yi.w.guy@intel.com
 

-----Original Message-----
From: Greg KH [mailto:greg@kroah.com] 
Sent: Sunday, June 21, 2009 7:49 PM
To: Arjan van de Ven
Cc: Linux Kernel Mailing List; Guy, Wey-Yi W
Subject: Re: iwlwifi: show qos AC parameters

On Sun, Jun 21, 2009 at 11:07:27AM -0700, Arjan van de Ven wrote:
> On Mon, 15 Jun 2009 21:14:13 GMT
> Linux Kernel Mailing List <linux-kernel@vger.kernel.org> wrote:
> 
> > +static ssize_t show_qos(struct device *d,
> > +				struct device_attribute *attr, char
> > *buf) +{
> > +	struct iwl_priv *priv = (struct iwl_priv *)d->driver_data;
> > +	char *p = buf;
> > +	int   q;
> > +
> > +	for (q = 0; q < AC_NUM; q++) {
> > +		p += sprintf(p, "\tcw_min\tcw_max\taifsn\ttxop\n");
> > +		p += sprintf(p, "AC[%d]\t%u\t%u\t%u\t%u\n", q,
> > +
> 
> wonder what happened to the "one value per file" sysfs rule...

Oh ick.

Thanks Arjan for the pointer.

Who's responsible for this file, and when is it going to be changed?

thanks,

greg k-h
