Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754582Ab0BONr1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Feb 2010 08:47:27 -0500
Received: from fg-out-1718.google.com ([72.14.220.155]:56845 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751660Ab0BONrZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Feb 2010 08:47:25 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=NZ/xmkZm0srodBUePudT1ltCSQJywQMJZeKf9QWPmGX2ibmUaf45MlN68vAi+KihJR
         3RI0evwtcZvrkoOcoo3/EkEeHzlyULtbsMVCKXsx9W9E/zmvQ4FSHpLLeXsWCM0wgSKe
         ZaDP/jZX44/S3tkMZgpvrs/XzRB9G81j7esQk=
Date: Mon, 15 Feb 2010 15:47:24 +0200
From: Alexey Dobriyan <adobriyan@gmail.com>
To: Dan Carpenter <error27@gmail.com>, kernel-janitors@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: bug list: range checking issues
Message-ID: <20100215134724.GA4107@x200>
References: <20100215124046.GB18821@bicker>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100215124046.GB18821@bicker>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Feb 15, 2010 at 03:40:56PM +0300, Dan Carpenter wrote:
> kernel/pid_namespace.c +96 create_pid_namespace(26) warn: buffer overflow 'ns->pidmap' 1 <= 1

What overflows exactly here?
