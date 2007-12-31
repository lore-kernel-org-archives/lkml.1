Return-Path: <linux-kernel-owner+w=401wt.eu-S1758895AbXLaLGI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758895AbXLaLGI (ORCPT <rfc822;w@1wt.eu>);
	Mon, 31 Dec 2007 06:06:08 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754642AbXLaLF5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 31 Dec 2007 06:05:57 -0500
Received: from smtp002.mail.ukl.yahoo.com ([217.12.11.33]:27712 "HELO
	smtp002.mail.ukl.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1754366AbXLaLF4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 31 Dec 2007 06:05:56 -0500
X-Greylist: delayed 406 seconds by postgrey-1.27 at vger.kernel.org; Mon, 31 Dec 2007 06:05:55 EST
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.it;
  h=Received:X-YMail-OSG:Message-ID:Date:From:User-Agent:MIME-Version:To:CC:Subject:References:In-Reply-To:X-Enigmail-Version:OpenPGP:Content-Type:Content-Transfer-Encoding;
  b=I2Fn4BIxGdYIWszCI1SXP4QqXcgehAXV+2pD3sua8odihLSGKG4vW0ZlLFu9i69Httwv9Jbu4RqWxeVDtrKhMe29Vdf7JBy/w8ZERlxutAs3dFJawZpquTlJYHUjMQCABKUffuUWkryoM1VYPCcEnQxkL3haRz56oVUgUOK8mX4=  ;
X-YMail-OSG: XuYbAZkVM1lnrhIN.h9h1i8WnMrKWq6MWK29t5ptwUn68W6LEuGCuzw9aaFA6LLR1U1LDv0XzvaU8BZWQalf1_RdmcrMvcN3Rl8UBdEmeuJ.pXJg
Message-ID: <4778CB78.2010906@yahoo.it>
Date: Mon, 31 Dec 2007 11:59:04 +0100
From: Filippo Zangheri <filippo.zangheri@yahoo.it>
User-Agent: Icedove 1.5.0.14pre (X11/20071018)
MIME-Version: 1.0
To: Marco Costalba <mcostalba@gmail.com>
CC: linux-kernel@vger.kernel.org
Subject: Re: [ANNOUNCE] qgit-2.1 and qgit-1.5.8
References: <e5bfff550712302335ie96e143g55c93e984fba6aaa@mail.gmail.com>
In-Reply-To: <e5bfff550712302335ie96e143g55c93e984fba6aaa@mail.gmail.com>
X-Enigmail-Version: 0.94.4.0
OpenPGP: id=E1D879FA;
	url=http://pgp.mit.edu:11371/pks/lookup?op=get&search=0xE1D879FA
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Marco Costalba wrote:
> Hi all,
> 
>   new versions of Qt4 based qgit-2.1 and stable Qt3 based qgit-1.5.8
> have been released.
> 
> Download tarballs from
> http://sourceforge.net/project/showfiles.php?group_id=139897
> 
> Or directly from git repositories
> 
> git://git.kernel.org/pub/scm/qgit/qgit.git   (qgit-1.5.8)
> git://git.kernel.org/pub/scm/qgit/qgit4.git  (qgit-2.1)
> 
> 
> Stable qgit-1.5.8 has only maintenance fixes, not a lot indeed, it
> happens to be already very stable.
> 
> New stuff is in qgit-2.1, you can find a detailed changelog at
> 
> http://git.kernel.org/?p=qgit/qgit.git;a=shortlog
> 
> 
> After popular request, this time I have packaged qgit-2.1 in a nice
> Windows installer (Inno Setup based) downloadable from the above
> sourceforge link, so that our Window's friends can try qgit without
> worrying about compilers, Qt libraries and other geeky things ;-)
> 
> Window installer will ask you to locate the msysgit directory. Indeed
> msysgit is the only supported git distribution under Windows, because
> Cygwin has some issues and is also muuuch slower.
> 
> So the only prerequisite is to have already installed msysgit
> (http://code.google.com/p/msysgit/)
> 
> 
> Happy new year 2008 !
> Marco

Hi,

I git-cloned qgit-2.1 from your repository, then ran `qmake qgit.pro`, but `make` gave me errors.
Afterwards I deleted src/Makefile, ran `qmake-qt4 qgit.pro` and `make` starts compiling some files but the process ends with other errors.
This is the command line:

filippo@master:/usr/src/git/qgit$ make
cd src && make -f Makefile 
make[1]: Entering directory `/usr/src/git/qgit/src'
make -f Makefile.Release
make[2]: Entering directory `/usr/src/git/qgit/src'
g++ -c -pipe -O2 -g3 -O2 -Wno-non-virtual-dtor -Wno-long-long -pedantic -Wconversion -Wall -W -D_REENTRANT  -DQT_NO_DEBUG -DQT_GUI_LIB -DQT_CORE_LIB -I../../../../share/qt4/mkspecs/linux-g++ -I. -I../../../../include/qt4/QtCore -I../../../../include/qt4/QtCore -I../../../../include/qt4/QtGui -I../../../../include/qt4/QtGui -I../../../../include/qt4 -I../src -I../build -I../build -o ../build/customactionimpl.o customactionimpl.cpp
make[2]: Leaving directory `/usr/src/git/qgit/src'
make[1]: Leaving directory `/usr/src/git/qgit/src'
../build/ui_customaction.h: In member function 'void Ui_CustomActionBase::setupUi(QWidget*)':
../build/ui_customaction.h:68: error: 'class QHBoxLayout' has no member named 'setLeftMargin'
../build/ui_customaction.h:69: error: 'class QHBoxLayout' has no member named 'setTopMargin'
../build/ui_customaction.h:70: error: 'class QHBoxLayout' has no member named 'setRightMargin'
../build/ui_customaction.h:71: error: 'class QHBoxLayout' has no member named 'setBottomMargin'
../build/ui_customaction.h:76: error: 'class QVBoxLayout' has no member named 'setLeftMargin'
../build/ui_customaction.h:77: error: 'class QVBoxLayout' has no member named 'setTopMargin'
../build/ui_customaction.h:78: error: 'class QVBoxLayout' has no member named 'setRightMargin'
../build/ui_customaction.h:79: error: 'class QVBoxLayout' has no member named 'setBottomMargin'
../build/ui_customaction.h:93: error: 'class QHBoxLayout' has no member named 'setLeftMargin'
../build/ui_customaction.h:94: error: 'class QHBoxLayout' has no member named 'setTopMargin'
../build/ui_customaction.h:95: error: 'class QHBoxLayout' has no member named 'setRightMargin'
../build/ui_customaction.h:96: error: 'class QHBoxLayout' has no member named 'setBottomMargin'
../build/ui_customaction.h:101: error: 'class QHBoxLayout' has no member named 'setLeftMargin'
../build/ui_customaction.h:102: error: 'class QHBoxLayout' has no member named 'setTopMargin'
../build/ui_customaction.h:103: error: 'class QHBoxLayout' has no member named 'setRightMargin'
../build/ui_customaction.h:104: error: 'class QHBoxLayout' has no member named 'setBottomMargin'
../build/ui_customaction.h:158: error: 'class QHBoxLayout' has no member named 'setLeftMargin'
../build/ui_customaction.h:159: error: 'class QHBoxLayout' has no member named 'setTopMargin'
../build/ui_customaction.h:160: error: 'class QHBoxLayout' has no member named 'setRightMargin'
../build/ui_customaction.h:161: error: 'class QHBoxLayout' has no member named 'setBottomMargin'
../build/ui_customaction.h:166: error: 'class QVBoxLayout' has no member named 'setLeftMargin'
../build/ui_customaction.h:167: error: 'class QVBoxLayout' has no member named 'setTopMargin'
../build/ui_customaction.h:168: error: 'class QVBoxLayout' has no member named 'setRightMargin'
../build/ui_customaction.h:169: error: 'class QVBoxLayout' has no member named 'setBottomMargin'
../build/ui_customaction.h:192: error: 'class QHBoxLayout' has no member named 'setLeftMargin'
../build/ui_customaction.h:193: error: 'class QHBoxLayout' has no member named 'setTopMargin'
../build/ui_customaction.h:194: error: 'class QHBoxLayout' has no member named 'setRightMargin'
../build/ui_customaction.h:195: error: 'class QHBoxLayout' has no member named 'setBottomMargin'
../build/ui_customaction.h:200: error: 'class QVBoxLayout' has no member named 'setLeftMargin'
../build/ui_customaction.h:201: error: 'class QVBoxLayout' has no member named 'setTopMargin'
../build/ui_customaction.h:202: error: 'class QVBoxLayout' has no member named 'setRightMargin'
../build/ui_customaction.h:203: error: 'class QVBoxLayout' has no member named 'setBottomMargin'
../build/ui_customaction.h:219: error: 'class QHBoxLayout' has no member named 'setLeftMargin'
../build/ui_customaction.h:220: error: 'class QHBoxLayout' has no member named 'setTopMargin'
../build/ui_customaction.h:221: error: 'class QHBoxLayout' has no member named 'setRightMargin'
../build/ui_customaction.h:222: error: 'class QHBoxLayout' has no member named 'setBottomMargin'
../build/ui_customaction.h:247: error: 'class QHBoxLayout' has no member named 'setLeftMargin'
../build/ui_customaction.h:248: error: 'class QHBoxLayout' has no member named 'setTopMargin'
../build/ui_customaction.h:249: error: 'class QHBoxLayout' has no member named 'setRightMargin'
../build/ui_customaction.h:250: error: 'class QHBoxLayout' has no member named 'setBottomMargin'
make[2]: *** [../build/customactionimpl.o] Error 1
make[1]: *** [release] Error 2
make: *** [sub-src-make_default] Error 2



I'm running Debian Etch 4.0 with vanilla kernel version 2.6.23.1 and I have the following packages installed:

filippo@master:/usr/src/git/qgit$ dpkg -l | grep qt4
ii libqt4-core			4.2.1-2+etch1	Qt 4 core non-GUI functionality runtime library
ii libqt4-dev			4.2.1-2+etch1	Qt 4 development files
ii libqt4-gui			4.2.1-2+etch1	Qt 4 core GUI functionality runtime library
ii libqt4-qt3support	4.2.1-2+etch1	Qt 3 compatibility library for Qt 4
ii libqt4-sql			4.2.1-2+etch1	Qt 4 SQL database module
ii qt4-dev-tools		4.2.1-2+etch1	Qt 4 development tools


what am I doing wrong?


Cheers.


-- 
Filippo Zangheri

GPG key ID: 0xE1D879FA
Key fingerprint: 816B CE57 D43C 0A47 EF35 3378 EA5F A72A E1D8 79FA
Key server: pgp.mit.edu
