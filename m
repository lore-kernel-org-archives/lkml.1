Return-Path: <linux-kernel-owner+w=401wt.eu-S1753420AbXCWUcU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753420AbXCWUcU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Mar 2007 16:32:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753421AbXCWUcU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 23 Mar 2007 16:32:20 -0400
Received: from wx-out-0506.google.com ([66.249.82.224]:57160 "EHLO
	wx-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753420AbXCWUcT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Mar 2007 16:32:19 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=IBFEAhUJ2wr/GrmzCJPYFa5u7p3K7694hCArjZIkEgGpDqmpKJWGgCoqaspiFUfmOFglC3pnM0ChW+iDXGdjQXC7Y66ViLGVcpUJpSwlFaCWzY7TxLWIh22OUnvyZGMdy89A1zcrfcas5RYH3oc90uKGi0wdXdReu4fU22hlKzw=
Message-ID: <d120d5000703231332q1c4a2e0epcba5c8b6c18d41fa@mail.gmail.com>
Date: Fri, 23 Mar 2007 16:32:18 -0400
From: "Dmitry Torokhov" <dmitry.torokhov@gmail.com>
To: "Yan Burman" <burman.yan@gmail.com>
Subject: Re: [PATCH 2.6.21-rc4] hwmon: HP Mobile Data Protection System 3D ACPI driver
Cc: linux-kernel@vger.kernel.org, khali@linux-fr.org
In-Reply-To: <1174661503.5373.16.camel@lapot>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <1174661503.5373.16.camel@lapot>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Yan,

On 3/23/07, Yan Burman <burman.yan@gmail.com> wrote:
> +
> +static unsigned int input_3d;
> +module_param(input_3d, bool, S_IRUGO);
> +MODULE_PARM_DESC(input_3d, "Operate as a 3D joystick instead of 2D");

Why do you need that? Just have the driver always report all 3 events
and have applications decide if they want to use ABS_Z events...

-- 
Dmitry
