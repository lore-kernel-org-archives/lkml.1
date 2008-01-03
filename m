Return-Path: <linux-kernel-owner+w=401wt.eu-S1759317AbYACLU3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759317AbYACLU3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Jan 2008 06:20:29 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753184AbYACLUT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 3 Jan 2008 06:20:19 -0500
Received: from rv-out-0910.google.com ([209.85.198.187]:32133 "EHLO
	rv-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751657AbYACLUS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Jan 2008 06:20:18 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:sender:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references:x-google-sender-auth;
        b=Ui3WGMARFV+s5XiptDMnJ5/VwsK02bAaUEKBpbC5UTQEQB6OhUutBkVDQjJw1ScxCFvLziovk/sYCes+2SuABRYq4w+cOzXMKNfAnjQlCi3dqwwpoA1NeEQ/bGEIE8e9ZjLZq7ira21QxnsJ/5Qy8cDerqAOxgt5bcUU0t2Al64=
Message-ID: <84144f020801030320y2bfb0b25v19587a1835da2242@mail.gmail.com>
Date: Thu, 3 Jan 2008 13:20:17 +0200
From: "Pekka Enberg" <penberg@cs.helsinki.fi>
To: "Arjan van de Ven" <arjan@linux.intel.com>
Subject: Re: [patch 1/3] move WARN_ON() out of line
Cc: linux-kernel@vger.kernel.org, "Ingo Molnar" <mingo@elte.hu>,
       "Andrew Morton" <akpm@linux-foundation.org>
In-Reply-To: <477C32DA.5060905@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <477C32DA.5060905@linux.intel.com>
X-Google-Sender-Auth: b9c7559516a4389f
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Arjan,

On Jan 3, 2008 2:56 AM, Arjan van de Ven <arjan@linux.intel.com> wrote:
> +int do_warn_on(const unsigned long condition, const char *file,
> +                       const int line, const char *function)
> +{
> +       if (unlikely(condition)) {
> +               printk(KERN_WARNING "WARNING: at %s:%d %s()\n",
> +                       __FILE__, __LINE__, __FUNCTION__);

I don't think you want to use __FILE__ and friends here...
