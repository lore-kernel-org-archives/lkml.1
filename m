Return-Path: <linux-kernel-owner+w=401wt.eu-S1754624AbZCJKPl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754624AbZCJKPl (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Mar 2009 06:15:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753673AbZCJKPc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Mar 2009 06:15:32 -0400
Received: from fg-out-1718.google.com ([72.14.220.154]:46133 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752266AbZCJKPb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Mar 2009 06:15:31 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=kItV7BP+eTToaHf+6F/04BYiaddesUrbXW51KqvRHazTpzYrfv+jU4CMYAS3FP6C80
         vLBZnirlF2+01Cr5PaGplcUxOMuimQ1D1VyqtG4lipyWls0sM3HvhK48OLZ4yrvDb3Zd
         JG1OkK8Y5uCfPNp0GQNcQE4szoZb8vjevPvJA=
Date: Tue, 10 Mar 2009 13:22:27 +0300
From: Alexey Dobriyan <adobriyan@gmail.com>
To: Stoyan Gaydarov <stoyboyker@gmail.com>
Cc: linux-kernel@vger.kernel.org, gregkh@suse.de
Subject: Re: [PATCH 02/25] [staging] BUG to BUG_ON changes
Message-ID: <20090310102227.GA2248@x200.localdomain>
References: <1236661850-8237-1-git-send-email-stoyboyker@gmail.com> <1236661850-8237-2-git-send-email-stoyboyker@gmail.com> <1236661850-8237-3-git-send-email-stoyboyker@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1236661850-8237-3-git-send-email-stoyboyker@gmail.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Mar 10, 2009 at 12:10:27AM -0500, Stoyan Gaydarov wrote:
> --- a/drivers/staging/usbip/vhci_sysfs.c
> +++ b/drivers/staging/usbip/vhci_sysfs.c
> @@ -31,8 +31,7 @@ static ssize_t show_status(struct device *dev, struct device_attribute *attr,
>  	char *s = out;
>  	int i = 0;
>  
> -	if (!the_controller || !out)
> -		BUG();
> +	BUG_ON(!the_controller || !out);

Should be deleted partially.

>  	spin_lock(&the_controller->lock);
