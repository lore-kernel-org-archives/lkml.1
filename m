Return-Path: <linux-kernel-owner+w=401wt.eu-S1753128AbYCNJdF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753128AbYCNJdF (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Mar 2008 05:33:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753463AbYCNJcx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 14 Mar 2008 05:32:53 -0400
Received: from sacred.ru ([62.205.161.221]:44724 "EHLO sacred.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752883AbYCNJcw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Mar 2008 05:32:52 -0400
Message-ID: <47DA4533.8030106@openvz.org>
Date: Fri, 14 Mar 2008 12:28:19 +0300
From: Pavel Emelyanov <xemul@openvz.org>
User-Agent: Thunderbird 2.0.0.12 (X11/20080213)
MIME-Version: 1.0
To: "Serge E. Hallyn" <serue@us.ibm.com>
CC: James Morris <jmorris@namei.org>, lkml <linux-kernel@vger.kernel.org>,
       linux-security-module@vger.kernel.org, Greg KH <greg@kroah.com>,
       Stephen Smalley <sds@epoch.ncsc.mil>,
       Casey Schaufler <casey@schaufler-ca.com>
Subject: Re: [RFC] cgroups: implement device whitelist lsm (v2)
References: <20080313032749.GA13258@sergelap.austin.ibm.com> <Xine.LNX.4.64.0803132022530.6358@us.intercode.com.au> <20080313131818.GA9771@sergelap.austin.ibm.com> <Xine.LNX.4.64.0803140049270.9059@us.intercode.com.au> <20080313143803.GA11265@sergelap.austin.ibm.com> <Xine.LNX.4.64.0803140925410.30342@us.intercode.com.au> <20080313224616.GA9139@sergelap.austin.ibm.com> <Xine.LNX.4.64.0803141046340.1545@us.intercode.com.au> <20080314014121.GA8320@sergelap.austin.ibm.com>
In-Reply-To: <20080314014121.GA8320@sergelap.austin.ibm.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH authentication, not delayed by milter-greylist-3.0 (sacred.ru [62.205.161.221]); Fri, 14 Mar 2008 12:28:21 +0300 (MSK)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Serge E. Hallyn wrote:
> Quoting James Morris (jmorris@namei.org):
>> On Thu, 13 Mar 2008, Serge E. Hallyn wrote:
>>
>>> Quoting James Morris (jmorris@namei.org):
>>>> On Thu, 13 Mar 2008, Serge E. Hallyn wrote:
>>>>
>>>>> True, but while this change simplifies the code a bit, the semantics
>>>>> seem more muddled - devcg will be enforcing when CONFIG_CGROUP_DEV=y
>>>>> and:
>>>>>
>>>>> 	SECURITY=n or
>>>>> 	rootplug is enabled
>>>>> 	capabilities is enabled
>>>>> 	smack is enabled
>>>>> 	selinux+capabilities is enabled
>>>> Well, this is how real systems are going to be deployed.
>>> Sorry, do you mean with capabilities?
>> Yes.
>>
>> All Fedora, RHEL, CentOS etc. ship with SELinux+capabilities.  I can't 
>> imagine not enabling them on other kernels.
>>
>>>> It becomes confusing, IMHO, if you have to change which secondary LSM you 
>>>> stack with SELinux to enable a cgroup feature.
>>> So you're saying selinux without capabilities should still be able to
>>> use dev_cgroup?  (Just making sure I understand right)
>> Nope, SELinux always stacks with capabilities, so havng the cgroup hooks 
>> in capabilities makes sense (rather than having us change the secondary 
>> stacking LSM just to enable a feature).
> 
> Oh, ok.
> 
> Will let the patch stand until Pavel and Greg comment then.

Well, I saw your previous patch, that was implemented as just another
LSM module and I liked it except for the LSM dependency.

Since this version can happily work w/o LSM, I like it too :)

> thanks,
> -serge
> 

