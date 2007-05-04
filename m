Return-Path: <linux-kernel-owner+w=401wt.eu-S1161804AbXEDJjh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161804AbXEDJjh (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 May 2007 05:39:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1161877AbXEDJjh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 4 May 2007 05:39:37 -0400
Received: from ug-out-1314.google.com ([66.249.92.173]:56990 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1161804AbXEDJjg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 May 2007 05:39:36 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:sender:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references:x-google-sender-auth;
        b=t+jo3tbxr74xlfpJN5Nd+6AON3VhfyYRdRuuW8XClfuoGOzinZiftVl/iHTUoc7dHEl//VK4YvxbsZTGFiGs2TurTB5sCywCwvXTHkZp3lyH8Ju4IFrq7kGSSg40nh6bvmVLGBBLsfla4ZaV7+sijXikVUvGT6L7aWpuIW72YBw=
Message-ID: <84144f020705040239l757b35b5jf3ab4cb0d4b1a016@mail.gmail.com>
Date: Fri, 4 May 2007 12:39:35 +0300
From: "Pekka Enberg" <penberg@cs.helsinki.fi>
To: "Randy Dunlap" <randy.dunlap@oracle.com>
Subject: Re: [PATCH v2] lib/hexdump
Cc: "Andrew Morton" <akpm@linux-foundation.org>,
       lkml <linux-kernel@vger.kernel.org>, jwboyer@linux.vnet.ibm.com,
       grant.likely@secretlab.ca, jketreno@linux.intel.com
In-Reply-To: <20070503174924.d0cbafa3.randy.dunlap@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20070502153556.3c995de7.randy.dunlap@oracle.com>
	 <20070502154557.b463c9c3.akpm@linux-foundation.org>
	 <46391730.2080003@oracle.com>
	 <20070502160635.31dd91e6.akpm@linux-foundation.org>
	 <20070502161533.cbf38b4b.randy.dunlap@oracle.com>
	 <20070503174924.d0cbafa3.randy.dunlap@oracle.com>
X-Google-Sender-Auth: 23a5b18b6f787f8a
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Randy,

On 5/4/07, Randy Dunlap <randy.dunlap@oracle.com> wrote:
> +extern void hex_dumper(void *buf, size_t len, char *linebuf, size_t linebuflen);

Please do s/hex_dumper/hex_dump_to_buffer/ for consistency with print_hex_dump.
