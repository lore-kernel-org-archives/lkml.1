Return-Path: <linux-kernel-owner+w=401wt.eu-S1763420AbYHEDom@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763420AbYHEDom (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Aug 2008 23:44:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754733AbYHEDoe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 4 Aug 2008 23:44:34 -0400
Received: from smtp101.prem.mail.sp1.yahoo.com ([98.136.44.56]:40594 "HELO
	smtp101.prem.mail.sp1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1754882AbYHEDod (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Aug 2008 23:44:33 -0400
X-YMail-OSG: Y8Pe3d0VM1kDNRrQgUKoDUIkeGsbX9q9IBVMMhxVrYFgdHJNBTTsC6h6wRPWT.PUvOvRi21OJAcsh4iepc3QTGIPqOuZTt4UMlJ4O.UxJxcswGQxRcwORfjYjBOWfK9Nt3w-
X-Yahoo-Newman-Property: ymail-3
Message-ID: <4897CC9C.2090906@schaufler-ca.com>
Date: Mon, 04 Aug 2008 20:44:28 -0700
From: Casey Schaufler <casey@schaufler-ca.com>
User-Agent: Thunderbird 2.0.0.16 (Windows/20080708)
MIME-Version: 1.0
To: Cliffe <cliffe@ii.net>
CC: Eric Paris <eparis@redhat.com>, malware-list@lists.printk.net,
       linux-kernel@vger.kernel.org, linux-security-module@vger.kernel.org
Subject: Re: [RFC 0/5] [TALPA] Intro to a linux interface for on access scanning
References: <1217883616.27684.19.camel@localhost.localdomain> <4897BFB4.9090309@schaufler-ca.com> <4897C2A7.7020601@ii.net>
In-Reply-To: <4897C2A7.7020601@ii.net>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Cliffe wrote:
> If we had stackable LSMs then the required functionality could simply 
> be built into the LSM interface. Then the anti-malware would simply 
> stack itself with other LSMs. In my opinion this is a perfect example 
> for the argument of stackable LSMs.

No argument from me.

> So far we mainly have LSMs which provide an extra access control 
> mechanism (in addition to DAC).

Yes. This is the design center for the LSM.

> IMHO, Ideally DAC could be another stackable LSM (enabled by default).

Yup. Search the archives for "authoritative hooks".

> Other security schemes such as intrusion detection, 
> firewalls/netfilter, anti-malware, and application restrictions 
> (sandboxes such as jails or finer grained restrictions such as 
> AppArmor) could all register LSMs onto the stack.

Stacking is easy for files. It's a real pain in the backside for UDP 
packets.

> Additional infrastructure would be necessary. Permissible security 
> remains a item of contention. Perhaps I am naive but I think most LSMs 
> could work based on accept/reject. Where every LSM must accept an 
> action in order for it to be carried out.

Please propose patches.

> MHO,

Oh, humility isn't all it's cracked up to be. Show us all up and
write the code. I'm serious, I don't think there's anyone here who
would object to a really good stacking scheme.

