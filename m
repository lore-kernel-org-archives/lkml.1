Return-Path: <linux-kernel-owner+w=401wt.eu-S1755040AbXEARct@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755040AbXEARct (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 May 2007 13:32:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755048AbXEARct
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 1 May 2007 13:32:49 -0400
Received: from e3.ny.us.ibm.com ([32.97.182.143]:39462 "EHLO e3.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755040AbXEARcs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 May 2007 13:32:48 -0400
Message-ID: <463779D4.9010507@us.ibm.com>
Date: Tue, 01 May 2007 12:33:08 -0500
From: "Steve French (smfltc)" <smfltc@us.ibm.com>
User-Agent: Mozilla Thunderbird 1.0 (Windows/20041206)
X-Accept-Language: en-us, en
MIME-Version: 1.0
To: linux-cifs-client@lists.samba.org, linux-kernel@vger.kernel.org,
       jengelh@linux01.gwdg.de
Subject: Re: linux-cifs-client Digest, Vol 42, Issue 1
References: <20070501101821.44AFA16386A@lists.samba.org>
In-Reply-To: <20070501101821.44AFA16386A@lists.samba.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> what also puzzles me... almost every filesystem that's not at revision 1
> anymore (ext2/3/4, reiser4, smb2) does not have the usually omnipresent "fs"
> suffix anymore (cf. reiserfs, smbfs).
> Maybe it's time to drop all the "fs" suffixes?  :) 

For the case of cifs (and nfs and afs) the "fs" is part of the name of 
the protocol ("common internet file system [protocol]") but for the 
other filesystems I agree that it seems redundant to put "fs" in the 
name (with a few exceptions e.g. "GFS2" would sound strange if named 
"G2" or "global2", and OCFS2 is presumably a product name).
