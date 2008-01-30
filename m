Return-Path: <linux-kernel-owner+w=401wt.eu-S1763663AbYA3Sxw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763663AbYA3Sxw (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Jan 2008 13:53:52 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761282AbYA3Sxd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 Jan 2008 13:53:33 -0500
Received: from py-out-1112.google.com ([64.233.166.181]:35392 "EHLO
	py-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760942AbYA3Sxc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Jan 2008 13:53:32 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=ZvlZLpCUImWdi+e6eBcKwGXX+ZXZsmgJBGy3ZaheSXj52JYaoWyRCyXxoe5h5oFiYIA6404gk6lkJNXKrzzjUll/wr84mPc0r/s67PJA4AAKsMHxo4QDeisM/Tkblmy7W2d700I9mKhrcyTvdm0pYqFlOt01DSjYvtA/Bi/XoRQ=
Message-ID: <524f69650801301053s370c9a2fpd03bf31616e37d9c@mail.gmail.com>
Date: Wed, 30 Jan 2008 12:53:28 -0600
From: "Steve French" <smfrench@gmail.com>
To: "Jan Engelhardt" <jengelh@computergmbh.de>
Subject: Re: [2.6 patch] remove smbfs
Cc: "Adrian Bunk" <bunk@kernel.org>, sfrench@samba.org,
       samba-technical@lists.samba.org, linux-kernel@vger.kernel.org
In-Reply-To: <Pine.LNX.4.64.0801301923450.13036@fbirervta.pbzchgretzou.qr>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20080128220835.GF8767@does.not.exist>
	 <Pine.LNX.4.64.0801301923450.13036@fbirervta.pbzchgretzou.qr>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I have mounted to Windows98 a few months ago with no problems (other
than a few restrictions like you can't set the file times via utimes).
 For mounts to Windows98 note that you have to specify the server
netbios name on the mount (since it is not the same as the DNS name).
In your example your would need to specify "servernetbiosname=WIN98"
in the mount options (until mount.cifs autoretries with
servernetbiosname assumed to be the beginning of the UNC name - note
that later servers have a dummy netbios name that is used so this
mount option is only needed for OS/2 and Win9x).

I will try mounts to Windows98 again.

On Jan 30, 2008 12:27 PM, Jan Engelhardt <jengelh@computergmbh.de> wrote:
>
> On Jan 29 2008 00:08, Adrian Bunk wrote:
> >
> >I remember that there were some small things missing in CIFS for
> >completely replacing the unmaintained smbfs when we discussed removing
> >smbfs back in 2005 due to smbfs being unmaintained.
> >
> >CIFS has improved since, smbfs is still unmaintained, and it's becoming
> >time to finally remove smbfs.
>
> Negative. CIFS as of 2.6.24-rc7 still does not support Windows 98,
> or at least, the mount command I tried was not the right one:
>
>         mount -t cifs //WIN98/c /mnt -o guest,sec=none
>
> (It is a test share with a null password open for anyone.) I am running
> out of options..
>
>         CIFS VFS: cifs_mount failed w/return code = -2
>



-- 
Thanks,

Steve
