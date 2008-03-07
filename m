Return-Path: <linux-kernel-owner+w=401wt.eu-S1765898AbYCGUp2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765898AbYCGUp2 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Mar 2008 15:45:28 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1764490AbYCGUpG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 7 Mar 2008 15:45:06 -0500
Received: from fmmailgate05.web.de ([217.72.192.243]:58433 "EHLO
	fmmailgate05.web.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1764354AbYCGUpF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Mar 2008 15:45:05 -0500
Date: Fri, 07 Mar 2008 21:44:07 +0100
Message-Id: <187848749@web.de>
MIME-Version: 1.0
From: devzero@web.de
To: renatoyamane@mandic.com.br
Cc: linux-kernel@vger.kernel.org
Subject: Re:Kernel Linux 2.6.23.16 hangs when run updatedb
Organization: http://freemail.web.de/
X-Provags-Id: V01U2FsdGVkX1+gKqd2fSHF4pCDp9MTKEiRgow1VdQ/1WoBvAlqEmWJLvLI+
 Ryxq+gabHmDmKe3bZRMaPivMg8RcFHjYqLnGGUibcttjE3LGA0=
Content-Type: text/plain; charset=iso-8859-15
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi !

looks like reiserfs issue.
maybe corrupt filesystem and improper handling of the reiserfs-driver?

could you try some "find /" ?

if that doesn`t trigger the problem, put your system under load and try again.

regards
roland


>when cron start updatedb daemon, my machine hangs. None key work, so I 
>need reset (press power button to restart).
>
>The only way to get log is runing updatedb from terminal (CTRL + ALT + 
>F1) and take a picture from screen:
>
>Up screen:
><http://img137.imageshack.us/img137/7128/01pg1.jpg>
>
>Down screen:
><http://img100.imageshack.us/img100/1456/02kx1.jpg>
>
>Call trace detail:
><http://img100.imageshack.us/img100/8233/calltracedetailsj7.jpg>
>
>.config is attached
>
>Regards,
>Renato S. Yamane
_________________________________________________________________________
In 5 Schritten zur eigenen Homepage. Jetzt Domain sichern und gestalten! 
Nur 3,99 EUR/Monat! http://www.maildomain.web.de/?mc=021114

