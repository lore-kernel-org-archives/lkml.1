Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753783Ab0BSAX2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Feb 2010 19:23:28 -0500
Received: from smtp13.ono.com ([62.42.230.16]:53961 "EHLO resmaa13.ono.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753723Ab0BSAXZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Feb 2010 19:23:25 -0500
Date: Fri, 19 Feb 2010 01:23:22 +0100
From: "J.A. =?UTF-8?B?TWFnYWxsw7Nu?=" <jamagallon@ono.com>
To: LKML <linux-kernel@vger.kernel.org>
Subject: NFSv4
Message-ID: <20100219012322.3d323794@werewolf.home>
X-Mailer: Claws Mail 3.7.5 (GTK+ 2.19.5; x86_64-mandriva-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi all...

First of all, kudos for new nfs-utils. Now, nfs4 works automagically and
like a charm.

And now the hard part, some questions:

- I have read that nfs4 includes in the server the locking protocol, no
  need for separate lockd. But in my servers, it seems it is still running:

root      2198     2  0 Feb18 ?        00:00:00 [nfsiod]
root     23501     2  0 01:01 ?        00:00:00 [nfsd4]
root     23502     2  0 01:01 ?        00:00:00 [nfsd]
root     23503     2  0 01:01 ?        00:00:00 [nfsd]
root     23504     2  0 01:01 ?        00:00:00 [nfsd]
root     23505     2  0 01:01 ?        00:00:00 [nfsd]
root     23506     2  0 01:01 ?        00:00:00 [nfsd]
root     23507     2  0 01:01 ?        00:00:00 [nfsd]
root     23508     2  0 01:01 ?        00:00:00 [nfsd]
root     23509     2  0 01:01 ?        00:00:00 [nfsd]
root     23500     2  0 01:01 ?        00:00:00 [lockd]

  Is there any problem with it ? I suppose (correct me if I'm wrong)
  that this kernel lockd will only serve for v2 or v3 mounts,
  that locking for client nfs4 mounts will go through nfsd4.
  Is that right ?

- Why is there only 1 instance of v4 daemon ?

- Is there any page describing the advantages of v4 ? I will have to
  convince the department admin to activate v4 in his solaris boxen...;)

TIA

Notes: kernel is 2.6.33-rc8, nfs-utils are 1.2.2.

-- 
J.A. Magallon <jamagallon()ono!com>     \               Software is like sex:
                                         \         It's better when it's free
