Return-Path: <linux-kernel-owner+w=401wt.eu-S1753966AbZFUSGo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753966AbZFUSGo (ORCPT <rfc822;w@1wt.eu>);
	Sun, 21 Jun 2009 14:06:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753524AbZFUSGh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 21 Jun 2009 14:06:37 -0400
Received: from casper.infradead.org ([85.118.1.10]:43442 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753488AbZFUSGg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 21 Jun 2009 14:06:36 -0400
Date: Sun, 21 Jun 2009 11:07:27 -0700
From: Arjan van de Ven <arjan@infradead.org>
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Cc: wey-yi.w.guy@intel.com, gregkh@kroah.com
Subject: Re: iwlwifi: show qos AC parameters
Message-ID: <20090621110727.74d95b28@infradead.org>
In-Reply-To: <200906152114.n5FLEDT3015406@hera.kernel.org>
References: <200906152114.n5FLEDT3015406@hera.kernel.org>
Organization: Intel
X-Mailer: Claws Mail 3.7.0 (GTK+ 2.14.7; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <arjan@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 15 Jun 2009 21:14:13 GMT
Linux Kernel Mailing List <linux-kernel@vger.kernel.org> wrote:

> +static ssize_t show_qos(struct device *d,
> +				struct device_attribute *attr, char
> *buf) +{
> +	struct iwl_priv *priv = (struct iwl_priv *)d->driver_data;
> +	char *p = buf;
> +	int   q;
> +
> +	for (q = 0; q < AC_NUM; q++) {
> +		p += sprintf(p, "\tcw_min\tcw_max\taifsn\ttxop\n");
> +		p += sprintf(p, "AC[%d]\t%u\t%u\t%u\t%u\n", q,
> +

wonder what happened to the "one value per file" sysfs rule...


-- 
Arjan van de Ven 	Intel Open Source Technology Centre
For development, discussion and tips for power savings, 
visit http://www.lesswatts.org
