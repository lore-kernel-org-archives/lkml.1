Return-Path: <linux-kernel-owner+w=401wt.eu-S1755458AbZIJKqA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755458AbZIJKqA (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Sep 2009 06:46:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753021AbZIJKp7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 10 Sep 2009 06:45:59 -0400
Received: from mail-fx0-f217.google.com ([209.85.220.217]:48167 "EHLO
	mail-fx0-f217.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752762AbZIJKp7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Sep 2009 06:45:59 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:subject:date:message-id:x-mailer:mime-version:content-type
         :content-transfer-encoding;
        b=lfdPcH6VT+nl6RqkYeT9T0tdVglgAwGZha+lP2Yu+sr6cwaml6Pfg8zPkF2c8yqdNO
         eCpn6VlIo5jwTgE5YnuX313+Sv9xz+TBdXBlP1S6FsmUS23+D+8vMXslHq3AmcK8bFcq
         Dt2Vk3z3gbuWnNCh8aTSodpKMiQYLaestEgeU=
From: =?UTF-8?q?Diego=20Elio=20=27Flameeyes=27=20Petten=C3=B2?= 
	<flameeyes@gmail.com>
To: linux-kernel@vger.kernel.org
Subject: [PATCH] gconfig: disable "typeahead find" search in treeviews.
Date: Thu, 10 Sep 2009 12:45:59 +0200
Message-Id: <1252579559-15513-1-git-send-email-flameeyes@gmail.com>
X-Mailer: git-send-email 1.6.4.2
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When typeahead find is enabled, using 'y', 'n' and 'm' to change the status
of the configuration items will also start up the search system, making you
jump around the configuration.

Disabling the enable_search property does not mean that search is not
possible, it only disables the typeahead; to execute a search in the
treeview, you can just call it up explicitly (i.e.: on most systems that
will be Ctrl-f).

Signed-off-by: Diego Elio 'Flameeyes' Pettenò <flameeyes@gmail.com>
---
 scripts/kconfig/gconf.glade |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/scripts/kconfig/gconf.glade b/scripts/kconfig/gconf.glade
index 803233f..b1c86c1 100644
--- a/scripts/kconfig/gconf.glade
+++ b/scripts/kconfig/gconf.glade
@@ -547,7 +547,7 @@
 		  <property name="headers_visible">True</property>
 		  <property name="rules_hint">False</property>
 		  <property name="reorderable">False</property>
-		  <property name="enable_search">True</property>
+		  <property name="enable_search">False</property>
 		  <signal name="cursor_changed" handler="on_treeview2_cursor_changed" last_modification_time="Sun, 12 Jan 2003 15:58:22 GMT"/>
 		  <signal name="button_press_event" handler="on_treeview1_button_press_event" last_modification_time="Sun, 12 Jan 2003 16:03:52 GMT"/>
 		  <signal name="key_press_event" handler="on_treeview2_key_press_event" last_modification_time="Sun, 12 Jan 2003 16:11:44 GMT"/>
@@ -582,7 +582,7 @@
 		      <property name="headers_visible">True</property>
 		      <property name="rules_hint">False</property>
 		      <property name="reorderable">False</property>
-		      <property name="enable_search">True</property>
+		      <property name="enable_search">False</property>
 		      <signal name="cursor_changed" handler="on_treeview2_cursor_changed" last_modification_time="Sun, 12 Jan 2003 15:57:55 GMT"/>
 		      <signal name="button_press_event" handler="on_treeview2_button_press_event" last_modification_time="Sun, 12 Jan 2003 15:57:58 GMT"/>
 		      <signal name="key_press_event" handler="on_treeview2_key_press_event" last_modification_time="Sun, 12 Jan 2003 15:58:01 GMT"/>
-- 
1.6.4.2

