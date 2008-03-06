Return-Path: <linux-kernel-owner+w=401wt.eu-S1763230AbYCFR4z@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763230AbYCFR4z (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Mar 2008 12:56:55 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752339AbYCFR4s
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 6 Mar 2008 12:56:48 -0500
Received: from gv-out-0910.google.com ([216.239.58.188]:57007 "EHLO
	gv-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751012AbYCFR4r (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Mar 2008 12:56:47 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:organization:to:subject:date:user-agent:cc:references:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:message-id;
        b=xBY5qHwWNLC8Z3YFyfHbUKlAmcCy36N3CDvGTdvFmuzQJVbuHMVxzxBdWM8URThQvPpA5PTc3pESyXKvlPwH76Jd1fkHr6FCPqomHmew6aHfJZqxGTANmhFPz787Lw4Ido34vvjyF+UeT8HbuzuW3o3XLwqym9c/i8qHfGXBiiE=
From: Balaji Rao <balajirrao@gmail.com>
Organization: National Institute of Technology, Karnataka
To: Greg KH <gregkh@suse.de>
Subject: Re: [PATCH] Mark kobjects as unitialized
Date: Thu, 6 Mar 2008 23:20:50 +0530
User-Agent: KMail/1.9.6 (enterprise 0.20071012.724442)
Cc: kvm-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org
References: <200803062223.18857.balajirrao@gmail.com> <20080306170514.GA13839@suse.de>
In-Reply-To: <20080306170514.GA13839@suse.de>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200803062320.50296.balajirrao@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 06 March 2008 10:35:14 pm Greg KH wrote:
<snip>
> Where exactly in the code does that happen?  kobjects should not be
> "reused" as that implies that they are static, and not dynamically
> allocated, right?
>
> Which kobject is this?
Yes, its static. Here's the code from virt/kvm_main.c:1269

static struct sys_device kvm_sysdev = {
        .id = 0,
        .cls = &kvm_sysdev_class,
};

this sys_device is being registered/unregistered when kvm-intel is 
loaded/unloaded.
>
> Ugh, is this the sys_device stuff?  I hate that code...
>
Yes it is! But, why do you hate it ?

-- 
regards,
balaji rao
3rd year,
Dept. of Mechanical Engineering,
National Institute of Technology, Karnataka
