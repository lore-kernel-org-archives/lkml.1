Return-Path: <linux-kernel-owner+w=401wt.eu-S1756494AbZKURHx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756494AbZKURHx (ORCPT <rfc822;w@1wt.eu>);
	Sat, 21 Nov 2009 12:07:53 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756371AbZKURHv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 21 Nov 2009 12:07:51 -0500
Received: from mail-yw0-f182.google.com ([209.85.211.182]:49597 "EHLO
	mail-yw0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756317AbZKURHo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 21 Nov 2009 12:07:44 -0500
X-Greylist: delayed 24686 seconds by postgrey-1.27 at vger.kernel.org; Sat, 21 Nov 2009 12:07:44 EST
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:content-transfer-encoding
         :in-reply-to:user-agent;
        b=l3jCs+zBLmWJItyaRIk1RKjovnG23jn0byZEZ1V1H6CnJs8OHrOl8fV98LoqWBRDSO
         1iO1ts1zObIRVuIZX4/0xzepZzxOUvZxfhzYAAHryB77ESFmM71Pg0403gkHzDVD15aB
         TCt8lkQWdvfWPTfmPw0hqd4vsZVUEDE/WTJ9Y=
Date: Sun, 22 Nov 2009 01:08:36 +0800
From: =?utf-8?Q?Am=C3=A9rico?= Wang <xiyou.wangcong@gmail.com>
To: Carmelo Amoroso <carmelo73@gmail.com>
Cc: =?utf-8?Q?Am=C3=A9rico?= Wang <xiyou.wangcong@gmail.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Carmelo AMOROSO <carmelo.amoroso@st.com>
Subject: Re: [PATCH] modules: Allow to use depmod from a non default install
Message-ID: <20091121170836.GF2412@hack>
References: <4AF73BA4.3000501@gmail.com> <20091109030622.GB2399@hack> <4B0800F6.1010709@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <4B0800F6.1010709@gmail.com>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Nov 21, 2009 at 04:02:14PM +0100, Carmelo Amoroso wrote:
>Américo Wang wrote:
>> On Sun, Nov 08, 2009 at 10:44:04PM +0100, Carmelo Amoroso wrote:
>>> This patch allow to specify the directory where to find the
>>> depmod tool other than being forced to use the module-init-tools
>>> installed on the host. The reason for this is explained below.
>>> When doing cross-compilation, it not guaranteed that the
>>> module-init-tools installed on the host (and used during kernel build)
>>> are exactly the same and compatible with those used on the target at runtime.
>>> For example, recent changes in how depmod writes modules.dep using
>>> root-less path, make older modprobe unusable on the target.
>>> User in ths case could install in a different path the module-init-tools
>>> compatible with the version used on the target and specify the path on the
>>> command line.
>>>
>>> Signed-off-by: Carmelo Amoroso <carmelo.amoroso@st.com>
>> 
>> Acked-by: WANG Cong <xiyou.wangcong@gmail.com>
>> 
>> 
>
>Hi,
>any plan to get it included ?
>

Hi,

I am not the maintainer, Sam was supposed to take this, but
yesterday, he just gave his position out. So I expect Andrew
or someone can take this.

Thanks.

-- 
Live like a child, think like the god.
 
