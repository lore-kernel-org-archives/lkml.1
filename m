Return-Path: <linux-kernel-owner+w=401wt.eu-S1758053AbZFWWx1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758053AbZFWWx1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Jun 2009 18:53:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752574AbZFWWxT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 23 Jun 2009 18:53:19 -0400
Received: from claw.goop.org ([74.207.240.146]:55781 "EHLO claw.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753138AbZFWWxS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Jun 2009 18:53:18 -0400
Message-ID: <4A415CDC.2090700@goop.org>
Date: Tue, 23 Jun 2009 15:53:16 -0700
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1b3pre) Gecko/20090513 Fedora/3.0-2.3.beta2.fc11 Lightning/1.0pre Thunderbird/3.0b2
MIME-Version: 1.0
To: Benjamin Herrenschmidt <benh@kernel.crashing.org>
CC: Matthew Wilcox <matthew@wil.cx>, Alex Chiang <achiang@hp.com>,
       jbarnes@virtuousgeek.org, linux-arch@vger.kernel.org,
       Kyle McMartin <kyle@mcmartin.ca>, Tony Luck <tony.luck@intel.com>,
       Russell King <linux@arm.linux.org.uk>, Arnd Bergmann <arnd@arndb.de>,
       Yoshinori Sato <ysato@users.sourceforge.jp>,
       Jeff Dike <jdike@addtoit.com>, linux-kernel@vger.kernel.org,
       Ralf Baechle <ralf@linux-mips.org>, David Howells <dhowells@redhat.com>,
       Paul Mundt <lethal@linux-sh.org>,
       Ivan Kokshaysky <ink@jurassic.park.msu.ru>,
       Ingo Molnar <mingo@redhat.com>, "David S. Miller" <davem@davemloft.net>,
       Avi Kivity <avi@redhat.com>, Ian Campbell <Ian.Campbell@eu.citrix.com>
Subject: Re: [PATCH] PCI: remove pcibios_scan_all_fns()
References: <20090622140807.25509.54448.stgit@bob.kio>	 <20090622143431.GT19977@parisc-linux.org> <4A3FCB68.3030004@goop.org>	 <20090622183056.GY19977@parisc-linux.org> <1245714008.4017.7.camel@pasglop>	 <20090623190826.GJ19977@parisc-linux.org>  <4A413C66.5010306@goop.org>	 <1245793758.10356.27.camel@pasglop>  <4A41562F.1040901@goop.org> <1245796916.10356.40.camel@pasglop>
In-Reply-To: <1245796916.10356.40.camel@pasglop>
X-Enigmail-Version: 0.96a
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/23/09 15:41, Benjamin Herrenschmidt wrote:
>> Do you have any other cases in mind where it would be helpful?
>>     
>
> Well, it might be for virtual device discovery etc... but don't bother
> now. We might talk about it at KS for those interested. It's more
> something we see as useful for embedded archs at the moment but in the
> long run it might make sense for hypervisors as well.
>   

Perhaps.  We have Xenbus - which is  a little bit like OF in that it has
data in a hierarchical namespace - and I guess it might be possible to
find a mapping onto some generic OF-like interface.  However, Xenbus is
an active communication channel between virtual machines rather than a
static representation of a machine configuration (for example, you can
put a watch on a particular path to get a notification of when someone
else changes it).

But, yes, this is a good KS hallway track subject.

    J
