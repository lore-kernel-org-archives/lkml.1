Return-Path: <linux-kernel-owner+w=401wt.eu-S1755989AbYCNPPy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755989AbYCNPPy (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Mar 2008 11:15:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753546AbYCNPPo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 14 Mar 2008 11:15:44 -0400
Received: from sacred.ru ([62.205.161.221]:52652 "EHLO sacred.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753316AbYCNPPn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Mar 2008 11:15:43 -0400
Message-ID: <47DA848C.3070901@openvz.org>
Date: Fri, 14 Mar 2008 16:58:36 +0300
From: Pavel Emelyanov <xemul@openvz.org>
User-Agent: Thunderbird 2.0.0.12 (X11/20080213)
MIME-Version: 1.0
To: "Serge E. Hallyn" <serue@us.ibm.com>
CC: Greg KH <greg@kroah.com>, James Morris <jmorris@namei.org>,
       lkml <linux-kernel@vger.kernel.org>,
       linux-security-module@vger.kernel.org,
       Stephen Smalley <sds@epoch.ncsc.mil>,
       Casey Schaufler <casey@schaufler-ca.com>,
       Pavel Emelianov <xemul@openvz.org>
Subject: Re: [RFC] cgroups: implement device whitelist lsm (v2)
References: <20080313032749.GA13258@sergelap.austin.ibm.com> <Xine.LNX.4.64.0803132022530.6358@us.intercode.com.au> <20080313131818.GA9771@sergelap.austin.ibm.com> <Xine.LNX.4.64.0803140049270.9059@us.intercode.com.au> <20080313143803.GA11265@sergelap.austin.ibm.com> <Xine.LNX.4.64.0803140925410.30342@us.intercode.com.au> <20080313224616.GA9139@sergelap.austin.ibm.com> <Xine.LNX.4.64.0803141046340.1545@us.intercode.com.au> <20080314014121.GA8320@sergelap.austin.ibm.com> <20080314044741.GB18077@kroah.com> <20080314135416.GD8744@sergelap.austin.ibm.com>
In-Reply-To: <20080314135416.GD8744@sergelap.austin.ibm.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH authentication, not delayed by milter-greylist-3.0 (sacred.ru [62.205.161.221]); Fri, 14 Mar 2008 16:58:41 +0300 (MSK)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[snip]

>> My main question was why was that file in the kernel/ directory?
>> Shouldn't that also be in the security/ directory?
> 
> I'm using cgroups to track the tasks which should have their device
> permissions restricted.  Right now cgroups are all under kernel/.

No. Memory cgroup is under mm/ :)

>> And to be honest, I didn't really look at it at all other than the
>> diffstat to make sure you weren't messing with the kobj_map stuff
>> anymore :)
>>
>> thanks,
>>
>> greg k-h
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-security-module" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 

