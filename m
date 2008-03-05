Return-Path: <linux-kernel-owner+w=401wt.eu-S1754632AbYCEPTU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754632AbYCEPTU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Mar 2008 10:19:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752085AbYCEPTF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 5 Mar 2008 10:19:05 -0500
Received: from nf-out-0910.google.com ([64.233.182.185]:52131 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751987AbYCEPTC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Mar 2008 10:19:02 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject:references:in-reply-to:x-enigmail-version:content-type:content-transfer-encoding;
        b=xYeHaXdSjXr7SAz7a72DFA4ATrDowdWbiP6XEv+W68tJQSJS5xdVhp6Hha1Al+ENLv3gYk04mO9vS7Q8sgj25wld5HAfNNg//GemA2c0wt2gbLIEC4BU1h4anJmfnLn/X5p1KgPzMWHstJTLeO/BwXhfq3ihltiUwzJdoVVoI/0=
Message-ID: <47CEB9DE.9060501@gmail.com>
Date: Wed, 05 Mar 2008 16:18:54 +0100
From: Jiri Slaby <jirislaby@gmail.com>
User-Agent: Thunderbird 2.0.0.12 (X11/20080213)
MIME-Version: 1.0
To: "Serge E. Hallyn" <serue@us.ibm.com>
CC: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       "Andrew G. Morgan" <morgan@kernel.org>,
       James Morris <jmorris@namei.org>, Stephen Smalley <sds@tycho.nsa.gov>,
       Paul Moore <paul.moore@hp.com>
Subject: Re: prctl(0x8) -> EINVAL [Was: 2.6.25-rc3-mm1]
References: <20080304011928.e8c82c0c.akpm@linux-foundation.org> <47CE7B1F.3000208@gmail.com> <20080305140624.GA9128@sergelap.austin.ibm.com>
In-Reply-To: <20080305140624.GA9128@sergelap.austin.ibm.com>
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/05/2008 03:06 PM, Serge E. Hallyn wrote:
> From 4a66f19580489a3ac84f0a145e4585c09e65c88e Mon Sep 17 00:00:00 2001
> From: Serge E. Hallyn <serue@us.ibm.com>
> Date: Wed, 5 Mar 2008 06:02:32 -0800
> Subject: [PATCH 1/1] capabilities: use cap_task_prctl when !CONFIG_SECURITY
> 
> capabilities-implement-per-process-securebits.patch introduced
> cap_task_prctl() and moved the handling of capability-related
> prctl into it.  So when !CONFIG_SECURITY, the default
> security_task_prctl() needs to call cap_task_prctl() the way
> other default hooks call capability helpers when they exist.
> 
> This fixes a slew of userspace breakages when
> CONFIG_SECURITY=n.
> 
> Signed-off-by: Serge E. Hallyn <serue@us.ibm.com>

Tested-by: Jiri Slaby <jirislaby@gmail.com>
