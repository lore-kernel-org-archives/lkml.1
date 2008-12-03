Return-Path: <linux-kernel-owner+w=401wt.eu-S1759716AbYLCUTL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759716AbYLCUTL (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Dec 2008 15:19:11 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754634AbYLCTzE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 3 Dec 2008 14:55:04 -0500
Received: from kroah.org ([198.145.64.141]:60572 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753325AbYLCTzD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Dec 2008 14:55:03 -0500
Date: Wed, 3 Dec 2008 11:53:40 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: Justin Forbes <jmforbes@linuxtx.org>,
       Zwane Mwaikambo <zwane@arm.linux.org.uk>,
       "Theodore Ts'o" <tytso@mit.edu>, Randy Dunlap <rdunlap@xenotime.net>,
       Dave Jones <davej@redhat.com>, Chuck Wolber <chuckw@quantumlinux.com>,
       Chris Wedgwood <reviews@ml.cw.f00f.org>,
       Michael Krufky <mkrufky@linuxtv.org>, Chuck Ebbert <cebbert@redhat.com>,
       Domenico Andreoli <cavokz@gmail.com>, Willy Tarreau <w@1wt.eu>,
       Rodrigo Rubira Branco <rbranco@la.checkpoint.com>,
       Jake Edge <jake@lwn.net>, Eugene Teo <eteo@redhat.com>,
       torvalds@linux-foundation.org, akpm@linux-foundation.org,
       alan@lxorguk.ukuu.org.uk, Steve French <smfrench@gmail.com>,
       Steve French <sfrench@us.ibm.com>,
       Suresh Jayaraman <sjayaraman@suse.de>
Subject: [patch 075/104] cifs: Fix build break
Message-ID: <20081203195340.GX8950@kroah.com>
References: <20081203193901.715896543@mini.kroah.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline; filename="cifs-fix-build-break.patch"
In-Reply-To: <20081203194725.GA8950@kroah.com>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.27-stable review patch.  If anyone has any objections, please let us know.

------------------
From: Steve French <sfrench@us.ibm.com>

commit c2b3382cd4d6c6adef1347e81f20e16c93a39feb upstream

Signed-off-by: Steve French <sfrench@us.ibm.com>
Cc: Suresh Jayaraman <sjayaraman@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 fs/cifs/cifs_debug.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/fs/cifs/cifs_debug.c
+++ b/fs/cifs/cifs_debug.c
@@ -249,9 +249,9 @@ static ssize_t cifs_stats_proc_write(str
 		list_for_each(tmp1, &cifs_tcp_ses_list) {
 			server = list_entry(tmp1, struct TCP_Server_Info,
 					    tcp_ses_list);
-			list_for_each(tmp2, &server->smb_session_list) {
+			list_for_each(tmp2, &server->smb_ses_list) {
 				ses = list_entry(tmp2, struct cifsSesInfo,
-						 smb_session_list);
+						 smb_ses_list);
 				list_for_each(tmp3, &ses->tcon_list) {
 					tcon = list_entry(tmp3,
 							  struct cifsTconInfo,

