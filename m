Return-Path: <linux-kernel-owner+w=401wt.eu-S1752918AbXEZXJR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752918AbXEZXJR (ORCPT <rfc822;w@1wt.eu>);
	Sat, 26 May 2007 19:09:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756407AbXEZXI7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 26 May 2007 19:08:59 -0400
Received: from nz-out-0506.google.com ([64.233.162.235]:40950 "EHLO
	nz-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752319AbXEZXI5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 26 May 2007 19:08:57 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=pjNs5Pfn3bmZ1v0NYkYbfclfY7LpYWnv3pquFlm52fHa/npvtdZVC8g94411hIVBkhPRU5A7W/2P/xJHxVz1mP7aSkjEVVZeXGtZyaCWWNSWpG6P/my99KH/J54P8+TCoMbBP2ny4Dywb23zc1+lvNMWEXu61cFDyytrSclEBcc=
Message-ID: <9d732d950705261608j4bc72cd4s4378df9848101c84@mail.gmail.com>
Date: Sun, 27 May 2007 08:08:56 +0900
From: "Toshiharu Harada" <haradats@gmail.com>
To: "James Morris" <jmorris@namei.org>
Subject: Re: [AppArmor 01/41] Pass struct vfsmount to the inode_create LSM hook
Cc: "Kyle Moffett" <mrmacman_g4@mac.com>, casey@schaufler-ca.com,
       "Andreas Gruenbacher" <agruen@suse.de>, linux-kernel@vger.kernel.org,
       linux-security-module@vger.kernel.org, linux-fsdevel@vger.kernel.org
In-Reply-To: <Line.LNX.4.64.0705261442000.23020@d.namei>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <309300.41401.qm@web36615.mail.mud.yahoo.com>
	 <B4A3C582-68F9-4077-B058-03B79A5577EB@mac.com>
	 <Line.LNX.4.64.0705261442000.23020@d.namei>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

2007/5/27, James Morris <jmorris@namei.org>:
> On Sat, 26 May 2007, Kyle Moffett wrote:
> > AppArmor).  On the other hand, if you actually want to protect the _data_,
> > then tagging the _name_ is flawed; tag the *DATA* instead.
>
> Bingo.
>
> (This is how traditional Unix DAC has always functioned, and is what
> SELinux does: object labeling).

Object labeling (or labeled security) looks simple and straight forward way,
but it's not.

(1) Object labeling has a assumption that labels are always properly
defined and maintained. This can not be easily achieved.
(2) Also, assigning a label is something like inventing and assigning
a *new* name (label name) to objects which can cause flaws.

 I'm not saying labeled security or SELinux is wrong.  I just wanted to
remind that  the important part is the "process" not the "result". :-)

-- 
Toshiharu Harada
haradats@gmail.com
