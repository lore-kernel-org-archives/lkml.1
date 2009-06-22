Return-Path: <linux-kernel-owner+w=401wt.eu-S1754351AbZFVCyY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754351AbZFVCyY (ORCPT <rfc822;w@1wt.eu>);
	Sun, 21 Jun 2009 22:54:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753369AbZFVCyQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 21 Jun 2009 22:54:16 -0400
Received: from kroah.org ([198.145.64.141]:36672 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751661AbZFVCyQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 21 Jun 2009 22:54:16 -0400
Date: Sun, 21 Jun 2009 19:48:38 -0700
From: Greg KH <greg@kroah.com>
To: Arjan van de Ven <arjan@infradead.org>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       wey-yi.w.guy@intel.com
Subject: Re: iwlwifi: show qos AC parameters
Message-ID: <20090622024838.GB18153@kroah.com>
References: <200906152114.n5FLEDT3015406@hera.kernel.org> <20090621110727.74d95b28@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090621110727.74d95b28@infradead.org>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

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
