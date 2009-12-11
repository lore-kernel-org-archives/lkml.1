Return-Path: <linux-kernel-owner+w=401wt.eu-S934894AbZLKIa6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934894AbZLKIa6 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Dec 2009 03:30:58 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760856AbZLKIay
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 11 Dec 2009 03:30:54 -0500
Received: from outbound.icp-qv1-irony-out1.iinet.net.au ([203.59.1.106]:64293
	"EHLO outbound.icp-qv1-irony-out1.iinet.net.au" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1760854AbZLKIax (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Dec 2009 03:30:53 -0500
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AtwAABOSIUt8qT8O/2dsb2JhbAAI1h6EKwSCew
X-IronPort-AV: E=Sophos;i="4.47,381,1257091200"; 
   d="scan'208";a="609358529"
Message-ID: <4B22032F.906@ii.net>
Date: Fri, 11 Dec 2009 16:30:39 +0800
From: Cliffe <cliffe@ii.net>
User-Agent: Thunderbird 2.0.0.23 (Windows/20090812)
MIME-Version: 1.0
To: apparmor-dev@forge.novell.com, selinux@tycho.nsa.gov,
       linux-kernel@vger.kernel.org, linux-security-module@vger.kernel.org,
       fbac-lsm-general@lists.sourceforge.net
Subject: New security system FBAC-LSM announcement and call for collaborators
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In preparation for my LCA talk “A New Paradigm for Restricting 
Applications and Protecting Yourself from Your Processes”, today I have 
released the code for FBAC-LSM. This initial development version of 
FBAC-LSM is functional, but is unstable and slow. It is developed 
against an older version of the LSM interface (using the AppArmor 
path-based hooks), and will be updated to work with the new interface in 
the future. There is quite a bit of work to be done before it is ready 
for production systems or formal code review.

I developed FBAC-LSM for my PhD research. FBAC-LSM restricts programs 
based on the features each application provides. Reusable policy 
abstractions, known as functionalities, can be used to grant the 
authority to perform high level features (for example using the 
Web_Browser functionality) or lower level features (such as using the 
HTTP_Client functionality) or to grant privileges to access any 
specified resources. Functionalities are parameterised, which allows 
them to be adapted to the needs of specific applications. 
Functionalities are also hierarchical; that is, functionalities can 
contain other functionalities.

Over one hundred applications were analysed, and functionalities and 
policies were developed. A number of techniques for automating aspects 
of policy specification were also developed. A usability study comparing 
FBAC-LSM with SELinux and AppArmor found that the new approach provided 
significant benefits including higher levels of user satisfaction and of 
successful policy creation. In the near future I will share the results 
of the usability study, including suggestions for improving the 
usability of SELinux and AppArmor.

Currently I am planning on expanding the FBAC-LSM tools to export to and 
manage AppArmor and SEEdit policies.

I am looking for anyone interested in collaborating on the project. 
Please contact me. There are a number of problems with the 
synchronisation in the LSM code, which I hope someone on one of these 
mailinglists can help with.

Programmed in C and C++, using the LSM and Qt frameworks. Policy 
abstractions in FBAC-LSM-PL policy language. Licensed GPL.

Check out the FBAC-LSM homepage which has lots more information and videos:
http://schreuders.org/FBAC-LSM

Pull the sourceforge Git repo (which includes the Linux Security Module 
(LSM), graphical policy manager, and policies) to your computer with the 
command:
git clone git://fbac-lsm.git.sourceforge.net/gitroot/fbac-lsm/fbac-lsm

If you are attending the 2010 linux.conf.au conference, I hope to see 
you at my talk in room Renouf 2 at 16:45 on Wednesday 20/01/10:
http://www.lca2010.org.nz/programme/schedule/view_talk/50029?day=wednesday

Thanks,

Z. Cliffe Schreuders
http://schreuders.org
PhD Candidate
Murdoch University


