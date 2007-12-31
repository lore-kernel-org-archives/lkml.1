Return-Path: <linux-kernel-owner+w=401wt.eu-S1759024AbXLaL6j@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759024AbXLaL6j (ORCPT <rfc822;w@1wt.eu>);
	Mon, 31 Dec 2007 06:58:39 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757457AbXLaL6a
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 31 Dec 2007 06:58:30 -0500
Received: from rv-out-0910.google.com ([209.85.198.188]:1789 "EHLO
	rv-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757382AbXLaL62 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 31 Dec 2007 06:58:28 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=NoHqy7R15V9PwJ+c/oAIiCm8r2lqC6BiE4/8zk7jBYBMYPr2oondFxqxiqPer2lOxubNEmwUbt3C+OiGRmItv9B3FPMn/txjRZ/20vGUgD9Z3me6aF/ybsDnyzMrSZTJf0LhpULDJBg6GDWpcgVCGCOh9EuJT2OL7UHRZDQCzsM=
Message-ID: <e5bfff550712310358g347d883fm9866f328f24e3ad0@mail.gmail.com>
Date: Mon, 31 Dec 2007 12:58:27 +0100
From: "Marco Costalba" <mcostalba@gmail.com>
To: "Filippo Zangheri" <filippo.zangheri@yahoo.it>
Subject: Re: [ANNOUNCE] qgit-2.1 and qgit-1.5.8
Cc: "Linux Kernel Development" <linux-kernel@vger.kernel.org>,
       "Git Mailing List" <git@vger.kernel.org>
In-Reply-To: <4778CB78.2010906@yahoo.it>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <e5bfff550712302335ie96e143g55c93e984fba6aaa@mail.gmail.com>
	 <4778CB78.2010906@yahoo.it>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Dec 31, 2007 11:59 AM, Filippo Zangheri <filippo.zangheri@yahoo.it> wrote:
>
> Hi,
>
> I git-cloned qgit-2.1 from your repository, then ran `qmake qgit.pro`, but `make` gave me errors.

Yes, you need qmake of Qt4 not the Qt3 one.

> Afterwards I deleted src/Makefile, ran `qmake-qt4 qgit.pro` and `make` starts compiling some files but the process ends with other errors.
> This is the command line:
>
> filippo@master:/usr/src/git/qgit$ make
> cd src && make -f Makefile
> make[1]: Entering directory `/usr/src/git/qgit/src'
> make -f Makefile.Release
> make[2]: Entering directory `/usr/src/git/qgit/src'
> g++ -c -pipe -O2 -g3 -O2 -Wno-non-virtual-dtor -Wno-long-long -pedantic -Wconversion -Wall -W -D_REENTRANT  -DQT_NO_DEBUG -DQT_GUI_LIB -DQT_CORE_LIB -I../../../../share/qt4/mkspecs/linux-g++ -I. -I../../../../include/qt4/QtCore -I../../../../include/qt4/QtCore -I../../../../include/qt4/QtGui -I../../../../include/qt4/QtGui -I../../../../include/qt4 -I../src -I../build -I../build -o ../build/customactionimpl.o customactionimpl.cpp
> make[2]: Leaving directory `/usr/src/git/qgit/src'
> make[1]: Leaving directory `/usr/src/git/qgit/src'
> ../build/ui_customaction.h: In member function 'void Ui_CustomActionBase::setupUi(QWidget*)':
> ../build/ui_customaction.h:68: error: 'class QHBoxLayout' has no member named 'setLeftMargin'
> ../build/ui_customaction.h:69: error: 'class QHBoxLayout' has no member named 'setTopMargin'

This is because you need at least Qt 4.3 as written in the README.

>
>
>
> I'm running Debian Etch 4.0 with vanilla kernel version 2.6.23.1 and I have the following packages installed:
>
> filippo@master:/usr/src/git/qgit$ dpkg -l | grep qt4
> ii libqt4-core                  4.2.1-2+etch1   Qt 4 core non-GUI functionality runtime library
> ii libqt4-dev                   4.2.1-2+etch1   Qt 4 development files
> ii libqt4-gui                   4.2.1-2+etch1   Qt 4 core GUI functionality runtime library
> ii libqt4-qt3support    4.2.1-2+etch1   Qt 3 compatibility library for Qt 4
> ii libqt4-sql                   4.2.1-2+etch1   Qt 4 SQL database module
> ii qt4-dev-tools                4.2.1-2+etch1   Qt 4 development tools
>
>
> what am I doing wrong?
>

Please upgrade to Qt 4.3 and everything will be OK ;-)


Happy new year
Marco
