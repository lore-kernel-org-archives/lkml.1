Return-Path: <linux-kernel-owner+w=401wt.eu-S1766636AbXEBTTA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1766636AbXEBTTA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 May 2007 15:19:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1766637AbXEBTTA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 2 May 2007 15:19:00 -0400
Received: from ug-out-1314.google.com ([66.249.92.171]:41766 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1766636AbXEBTS6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 May 2007 15:18:58 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=gV0diPHrVr83J/2Dtho7fRSjU9IBNClGRalLf1remMXrnJGubE9UEKwraghkHpgwTPEDGzHb7yeCfM8gX8VoZxy1nlMQDlnicubUHy/agbAOfsnn1CGHdtxOFsC2disqsbu60npc3Jj2QxozI/CSSNLjuMnuawhnQwIxIoeaRug=
Message-ID: <f058a9c30705021218p4fdb4747kb5b4b9000ad50ef2@mail.gmail.com>
Date: Wed, 2 May 2007 20:18:55 +0100
From: "Miguel Sousa Filipe" <miguel.filipe@gmail.com>
To: linux-kernel@vger.kernel.org
Subject: FEATURE REQUEST: merge MD software raid and LVM in one unique layer.
In-Reply-To: <f058a9c30705021214k75da330ai4d79a2b6b2806652@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <f058a9c30705021214k75da330ai4d79a2b6b2806652@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hello kernel hackers,

Some weeks ago, in a ZFS related thread, some kernel hackers asked the
user what did they liked in ZFS that linux didn't have, so that they
could (possibly) work on it.

So, here is my feature request:
- merge MD software raid framework and LVM in one unique
API/framework, to be controled/managed by one unique userland
toolset.


Any sysadmin which needs to do device & volume management and FS
management in Linux has do use three diferent tools, for 3 diferent
layers (that I think shouldn't be 3 layers.. but only 2).
- md :
   MD is a software raid framework, with raid0, 1, 4, 5, 6, append and others..
- lvm :
  The logical volume manager: this allows you to manage logical disks
(devices), grow a  device, add phisical devices to a existing volume,
snapshot.. etc..
- fs
 duh... the FileSystem level.


However, MD and LVM have feature replications:
- raid1 / mirroring
- raid0 / stripping
- append / concatenate

I find it high irritanting having two kernel interfaces and two
userland tools that provide the same funcionality, which one should I
use?

I also don't understand from the point of view of code maintenance..
shurely there is some unneeded duplicate code lying in the kernel
tree.

One of the  good things (my opinion) about ZFS is putting these things
in one unique place, with a good user interface (the zpool & other zfs
command tools are quite easy and simple to use).

On linux, I find myself having to setup each layer by hand, each with
its own peculiarities and command line tools.. I consede that maybe
the FS layer and the device management layer shouldn't be merged.
But clearly that in Linux we have too different layers (that aren't
really layers since they do not depend on one another) for the same
purpose:
- device manangement.

I'm no kernel hacker, I'm just a simple user, but this is my *pretty
please* that some kernel hackers work together to unite and simplify
the work that has to be made to use software raid and volume
management on Linux.

In essence, I believe that bringing the funcionality that is unique to
MD integrated in LVM would suffice (leaving MD there for legacy compat.. but
warning users about future improvements on LVM only)

Thank you very much,


PS: I'm not subscribed to lkml yet, please CC me any reply
-- 
Miguel Sousa Filipe
