Return-Path: <linux-kernel-owner+w=401wt.eu-S1753255AbXDTK60@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753255AbXDTK60 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Apr 2007 06:58:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753394AbXDTK60
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 20 Apr 2007 06:58:26 -0400
Received: from fmmailgate04.web.de ([217.72.192.242]:49072 "EHLO
	fmmailgate04.web.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753255AbXDTK6Z convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Apr 2007 06:58:25 -0400
Date: Fri, 20 Apr 2007 12:58:23 +0200
Message-Id: <1748246099@web.de>
MIME-Version: 1.0
From: devzero@web.de
To: albcamus@gmail.com
Cc: jdike@addtoit.com, linux-kernel@vger.kernel.org
Subject: RE: VMWare Workstation 6 for debugging Linux Kernel (!)
Organization: http://freemail.web.de/
Content-Type: text/plain; charset=iso-8859-15
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

>  It's really an interesting feature,  IMHO,  maybe the UML would be no
> more needed.

if you speak of debugging , uml seems to have another competitor now.

maybe somebody make some side by side comparison of vmware & uml regarding kernel debugging. (and also compare that to traditional debugging via serial line or network)

regards
roland



> -----Ursprüngliche Nachricht-----
> Von: albcamus <albcamus@gmail.com>
> Gesendet: 20.04.07 09:16:53
> An: roland <devzero@web.de>
> CC: linux-kernel@vger.kernel.org
> Betreff: RE: VMWare Workstation 6 for debugging Linux Kernel (!)


> 
> Hi roland,
>  It's really an interesting feature,  IMHO,  maybe the UML would be no
> more needed.
> thanks very much;-)
> 
> Regards,
> 
> 
> 2007/4/20, roland <devzero@web.de>:
> > Hi !
> >
> > I think this one is damn interestig for linux kernel development:
> >
> > link: http://stackframe.blogspot.com/
> > contents: see below
> >
> > regards
> > roland
> >
> > ps:
> > i`m not directly related to vmware - so this is no advertisement!
> >
> >
> > Tuesday, April 17, 2007
> > Debugging Linux kernels with Workstation 6.0
> > We just quietly added an exciting feature to Workstation 6.0. I believe it
> > will make WS6 a great tool for Linux kernel development. You can now debug
> > kernel of Linux VM with gdb running on the Host without changing anything in
> > the Guest VM. No kdb, no recompiling and no need for second machine. All you
> > need is a single line in VM's configuration file.
> >
> > To use the new feature, grab the latest build of WS6 here:
> >
> > http://www.vmware.com/products/beta/ws/
> >
> > Put this line into configuration file of your Linux VM:
> >
> > debugStub.listen.guest32=1
> >
> > Now whenever you run the virtual machine, you'll see the following on the
> > Host console:
> >
> > VMware Workstation is listening for debug connection on port 8832.
> >
> > Run gdb on the Host, reference it to the kernel with symbols and attach to
> > the virtual machine:
> >
> > % gdb
> > (gdb) file vmlinux-2.4.21-27.EL.debug
> > (gdb) target remote localhost:8832
> >
> > That's it. The VM is blocked now, so you can "continue" it and "^C" back to
> > gdb. Breakpoints, single step, memory inspection - all this works as usual.
> > If you have SMP VM, then each VCPU is mapped on a thread, so use "info
> > threads" and "thread NN" to switch between them.
> >
> > The kernels with symbols are sadly lacking on most distributions, but if you
> > use RHEL then this website may help (look for kernel-debuginfo rpm):
> >
> > http://people.redhat.com/duffy/debuginfo/index-js.html
> >
> > The gdb support in WS6 is experimental, so there may be rough edges here and
> > there. Please post on community forums if something doesn't work right or if
> > you have a suggestion:
> >
> > http://www.vmware.com/community/
> >
> > There are more debugging specific features in WS6 (for example, you can use
> > gdb hand-in-hand with Record/Replay!). I will describe them shortly.
> >
> >
> >
> >
> > -
> > To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> > the body of a message to majordomo@vger.kernel.org
> > More majordomo info at  http://vger.kernel.org/majordomo-info.html
> > Please read the FAQ at  http://www.tux.org/lkml/
> >
> 


_______________________________________________________________
SMS schreiben mit WEB.DE FreeMail - einfach, schnell und
kostenguenstig. Jetzt gleich testen! http://f.web.de/?mc=021192

