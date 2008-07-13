Return-Path: <linux-kernel-owner+w=401wt.eu-S1755624AbYGMTNX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755624AbYGMTNX (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 Jul 2008 15:13:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754043AbYGMTNO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 13 Jul 2008 15:13:14 -0400
Received: from gv-out-0910.google.com ([216.239.58.185]:36659 "EHLO
	gv-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753615AbYGMTNO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 Jul 2008 15:13:14 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=ec6pIjUNH1yPRYN1nYzBZ/DInYqu08V7jWcPwFOU5ud7zYUBoQGoBsSQ21ICINbsfF
         9KpxCKGrFaOlctuVFdMfub5wrF8lTYZYtvqxBwjyH/VUs53ZwLt4TR4TVBbI6Raa9/uN
         OdK7WYak8q0ODl9k3OUgFWYdhcOcW2yNxdYo0=
Message-ID: <487A53C1.5000308@gmail.com>
Date: Sun, 13 Jul 2008 21:13:05 +0200
From: Jiri Olsa <olsajiri@gmail.com>
User-Agent: Thunderbird 2.0.0.9 (X11/20071031)
MIME-Version: 1.0
To: David Miller <davem@davemloft.net>
CC: tgraf@suug.ch, johannes@sipsolutions.net, linux-kernel@vger.kernel.org
Subject: Re: genetlink: genl_unregister_mc_group
References: <4878D9D3.1020109@gmail.com> <20080712.135031.193694627.davem@davemloft.net>
In-Reply-To: <20080712.135031.193694627.davem@davemloft.net>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

David Miller wrote:
> From: Jiri Olsa <olsajiri@gmail.com>
> Date: Sat, 12 Jul 2008 18:20:35 +0200
> 
>> is there a special reason why genl_unregister_mc_group 
>> is not exported for module usage?
> 
> When there is an in-tree modular use of this function, we
> will export it.

I'd like to dynamically add and remove multicast groups in my module,
and I'd like to use a genetlink...
Any idea besides the design change or leaving the genetlink? :)

Jiri Olsa
