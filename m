Return-Path: <linux-kernel-owner+w=401wt.eu-S1764016AbYHHW06@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764016AbYHHW06 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Aug 2008 18:26:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1764310AbYHHW0m
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 8 Aug 2008 18:26:42 -0400
Received: from py-out-1112.google.com ([64.233.166.176]:40625 "EHLO
	py-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760034AbYHHW0j convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Aug 2008 18:26:39 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=UxEin7BCrVx8Zqup3PGpkEwfP8r+anQuO3CLZtuybixAuQ5kH0SjZnNuWXtokkMEJ4
         TWF1WE408o6MBhFSUbpYeKGFIGgDsqau4dgOo4WnOG9ISbYDz0HCF9WUnuri5bQwacHn
         ndpDR5RNRJ7+K75aU/kAxCDG3qF6UX0ywNdhQ=
Message-ID: <e7d8f83e0808081526v1ed1a79by590b62aead222a85@mail.gmail.com>
Date: Sat, 9 Aug 2008 08:26:37 +1000
From: "Peter Dolding" <oiaohm@gmail.com>
To: "=?ISO-8859-1?Q?J=F6rg_Ostertag?=" <Joerg.Ostertag@avira.com>
Subject: Re: [malware-list] Threat model for Unix Computers
Cc: "Theodore Tso" <tytso@mit.edu>, "Rik van Riel" <riel@redhat.com>,
       "Eric Paris" <eparis@redhat.com>, "Greg KH" <greg@kroah.com>,
       "Al Viro" <viro@zeniv.linux.org.uk>,
       "Press, Jonathan" <Jonathan.Press@ca.com>,
       "Arjan van de Ven" <arjan@infradead.org>, linux-kernel@vger.kernel.org,
       malware-list@lists.printk.net, linux-security-module@vger.kernel.org
In-Reply-To: <200808081248.55590.Joerg.Ostertag@avira.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
References: <20080805211445.GA28304@kroah.com>
	 <20080805204600.03ceca31@bree.surriel.com>
	 <20080806014435.GF8224@mit.edu>
	 <200808081248.55590.Joerg.Ostertag@avira.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Aug 8, 2008 at 8:48 PM, Jörg Ostertag <Joerg.Ostertag@avira.com> wrote:
> Am Mittwoch, 6. August 2008 03:44 schrieb Theodore Tso:
>> On Tue, Aug 05, 2008 at 08:46:00PM -0400, Rik van Riel wrote:
>
> ...
>
> I'm trying to fill in some other thread models, not all directly related to
> virus-scanning, but if we want to get a complete anti-threat model for linux,
> we should take them into account too.
> In addition I'll add some usage scenarios for later extracting some threat
> scenarios ...
>
> Desktop-Users:
> ----------------------
>>       The Linux Desktop (where clueless users may be tricked into
>>               running malware).
>
> I would add the chance of users exporting there locally stored Files via CIFS,
> SMB, http, ... for accessing them with there beloveled streaming clients.
>
> Speaking of exporting Files from a Desktop PC  we should also take in account
> File-Sharing clients.
>
> Some more examples of a Desktop Users desire would be:
>        - copying Files to/from there PDA (BT,USB,WLAN)
>        - sharing internet connection with there PDA (BT,USB,WLAN)
>
> Another threads would be:
>        - giving access to the Desktop-PC to guest-users for
>                 "just let me look up something in the internet"
>          and the guest-user on the Desktop not informing about the (in his point of
>          view) urgent installation of there beloved
>          Browser-malware^H^H^H^H^H -adware ^H^H^H^H^H -extention
>
> For all the Files stored on the Desktop PC we should also take in account,
> that the paranoid Desktop user would store them inside a crypted
> device/container. Some examples would be: truecrypt-container/-partition,
> External crypted Harddrive, ...
>
> ... speaking of storing Files I would expect even Desktop Homeusers to store
> there Files on a local mini Fileserver (like a Fritz-Box, NSLU2, ...) to
> share them with other devices like Multimedia players, ...
>
> Notebook-Users:
> ------------------------
> And then we have the Linux Notebook users. I separate these from the Desktop
> users, because they will have most of the Scenarios for Desktop users plus
> some additional treats.
>        - Connecting to random accesspoints (Airports, Hotels, ...)
>        - Exporting there Wireless (BT,WLAN,UMTS, ...) to random people. Sometimes
>          willingly, sometimes unwillingly
>        - leaving there Notebooks unattended
>                - without Bios password
>                - without HDD-encrytion
>                - without Boot-Manager Password
>                - without screenlock
>                - ...
>
> Linux Desktops in public places:
> --------------------------------------------
> I'm thinking of Linux Desktop PCs in places like Internet-Cafe,
> Public-Library, School, ...
> These would be similar to the Standard Linux Desktop but adding some
> additional threats.
>        - willingly trying to attack the PC with physical access to
>                - CD-Rom
>                - USB-Devices
>                        USB-Stick
>                        Card Reader
>                - Network cable
>                - Floppy drive (if still existing)
>                - Reset Button
>
>
>>       The Linux File Server (where it is *highly* unlikely to have
>>               active running malware, since there are no clueless
>>               users running on said file server), but where malware
>>               may be stored and read over CIFS, NFS, etc.
>
> Maybe it "was" unlikely, but you can see more and more
> (Now-)Unix-administrators originally used to other operating systems and with
> a different view to security. So it would be nice if we would be able to
> protect these users/admins/installations too.
>
> Mail-Proxy:
> --------------
>>       The Linux Mail server is really a restricted case of the Linux
>>               Fileserver; where the only way in is SMTP, and the
>>               only protocol out is IMAP/POP.
>
> I would add SMTP for the outgoing channel too.
>
>
> Web-Proxy:
> ----------------
> Only to complete the list:
>              The Linux Web Proxy is another example of a Linux Server.
>                The way in would be http traffic (mostly over port
>                80 and 443) and the way out will be either over a shared
>                proxy port or offered transparent if the Linux machine is used
>                as router.
>
> In my opinion all good webproxies with scanner already provide a pretty good
> solution here.
>
>
Software Conflits
------------------------
Anti-virus Software conflicting with other secuirty software.  This is
a design issue on Windows and some of the hooks different companies
have tried to develop for the Linux world.

Linux systems can have HIDS and other non anti-virus monitoring
software.   On windows realtime scanning can be crippled if you
install 2 anti-viruses at a time due to stuffing up each others hooks.
  We need to avoid this on Linux.  There is more that will want to
monitor the same things as a Antivirus on Linux looking for different
kinds of problems.   Yes the first platform where 1 alone running does
not cut it.

Peter Dolding
