Return-Path: <linux-kernel-owner+w=401wt.eu-S1753463AbZC2XYq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753463AbZC2XYq (ORCPT <rfc822;w@1wt.eu>);
	Sun, 29 Mar 2009 19:24:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751390AbZC2XYh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 29 Mar 2009 19:24:37 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:42914 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751043AbZC2XYg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 29 Mar 2009 19:24:36 -0400
Date: Mon, 30 Mar 2009 01:24:22 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Alexey Dobriyan <adobriyan@gmail.com>
Cc: linux-kernel@vger.kernel.org, "H. Peter Anvin" <hpa@zytor.com>,
       Thomas Gleixner <tglx@linutronix.de>
Subject: Re: fault.c cleanup, what else could it be
Message-ID: <20090329232422.GA9873@elte.hu>
References: <20090329175642.GA26405@x200.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090329175642.GA26405@x200.localdomain>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Alexey Dobriyan <adobriyan@gmail.com> wrote:

> I have personally stopped sending anything against pure arch/x86/ 
> if there is even a smallest chance it can be prettyfied like this.

Before you volunteer reviewing x86 code for us (thanks for that!), 
may i direct your urgent attention at code in your own area of 
responsibility - such as fs/proc/base.c:

    total: 85 errors, 39 warnings, 2 checks, 3147 lines checked

I filtered out the relevant ones for you below.

Thanks,

	Ingo

---------------->
ERROR: space required before the open parenthesis '('
#154: FILE: proc/base.c:154:
+	if(fs)

ERROR: code indent should use tabs where possible
#276: FILE: proc/base.c:276:
+ ^Ilen = mm->arg_end - mm->arg_start;$

ERROR: trailing whitespace
#277: FILE: proc/base.c:277:
+ $

ERROR: trailing whitespace
#280: FILE: proc/base.c:280:
+ $

ERROR: do not use C99 // comments
#283: FILE: proc/base.c:283:
+	// If the nul at the end of args has been overwritten, then

ERROR: do not use C99 // comments
#284: FILE: proc/base.c:284:
+	// assume application is using setproctitle(3).

WARNING: suspect code indent for conditional statements (16, 20)
#287: FILE: proc/base.c:287:
+		if (len < res) {
+		    res = len;

WARNING: externs should be avoided in .c files
#452: FILE: proc/base.c:452:
+unsigned long badness(struct task_struct *p, unsigned long uptime);

ERROR: "foo * bar" should be "foo *bar"
#722: FILE: proc/base.c:722:
+static ssize_t proc_info_read(struct file * file, char __user * buf,

ERROR: "foo * bar" should be "foo *bar"
#725: FILE: proc/base.c:725:
+	struct inode * inode = file->f_path.dentry->d_inode;

ERROR: do not use assignment in if condition
#738: FILE: proc/base.c:738:
+	if (!(page = __get_free_page(GFP_TEMPORARY)))

ERROR: "(foo*)" should be "(foo *)"
#741: FILE: proc/base.c:741:
+	length = PROC_I(inode)->op.proc_read(task, (char*)page);

ERROR: "foo* bar" should be "foo *bar"
#795: FILE: proc/base.c:795:
+static int mem_open(struct inode* inode, struct file* file)

ERROR: "(foo*)" should be "(foo *)"
#797: FILE: proc/base.c:797:
+	file->private_data = (void*)((long)current->self_exec_id);

ERROR: "foo * bar" should be "foo *bar"
#801: FILE: proc/base.c:801:
+static ssize_t mem_read(struct file * file, char __user * buf,

ERROR: trailing whitespace
#822: FILE: proc/base.c:822:
+ $

ERROR: trailing whitespace
#828: FILE: proc/base.c:828:
+ $

ERROR: "(foo*)" should be "(foo *)"
#829: FILE: proc/base.c:829:
+	if (file->private_data != (void*)((long)current->self_exec_id))

ERROR: trailing whitespace
#833: FILE: proc/base.c:833:
+ $

ERROR: trailing whitespace
#849: FILE: proc/base.c:849:
+ $

ERROR: "foo * bar" should be "foo *bar"
#871: FILE: proc/base.c:871:
+static ssize_t mem_write(struct file * file, const char __user *buf,

ERROR: trailing whitespace
#909: FILE: proc/base.c:909:
+^I^Icount -= retval;^I^I^I$

ERROR: "foo * bar" should be "foo *bar"
#1070: FILE: proc/base.c:1070:
+static ssize_t proc_loginuid_read(struct file * file, char __user * buf,

ERROR: "foo * bar" should be "foo *bar"
#1073: FILE: proc/base.c:1073:
+	struct inode * inode = file->f_path.dentry->d_inode;

ERROR: "foo * bar" should be "foo *bar"
#1086: FILE: proc/base.c:1086:
+static ssize_t proc_loginuid_write(struct file * file, const char __user * buf,

ERROR: "foo * bar" should be "foo *bar"
#1089: FILE: proc/base.c:1089:
+	struct inode * inode = file->f_path.dentry->d_inode;

ERROR: "(foo*)" should be "(foo *)"
#1107: FILE: proc/base.c:1107:
+	page = (char*)__get_free_page(GFP_TEMPORARY);

ERROR: "foo * bar" should be "foo *bar"
#1135: FILE: proc/base.c:1135:
+static ssize_t proc_sessionid_read(struct file * file, char __user * buf,

ERROR: "foo * bar" should be "foo *bar"
#1138: FILE: proc/base.c:1138:
+	struct inode * inode = file->f_path.dentry->d_inode;

ERROR: "foo * bar" should be "foo *bar"
#1157: FILE: proc/base.c:1157:
+static ssize_t proc_fault_inject_read(struct file * file, char __user * buf,

ERROR: "foo * bar" should be "foo *bar"
#1175: FILE: proc/base.c:1175:
+static ssize_t proc_fault_inject_write(struct file * file,

ERROR: "foo * bar" should be "foo *bar"
#1176: FILE: proc/base.c:1176:
+			const char __user * buf, size_t count, loff_t *ppos)

ERROR: space required before the open brace '{'
#1281: FILE: proc/base.c:1281:
+	if ((mm->num_exe_file_vmas == 0) && mm->exe_file){

ERROR: "(foo*)" should be "(foo *)"
#1363: FILE: proc/base.c:1363:
+	char *tmp = (char*)__get_free_page(GFP_TEMPORARY);

ERROR: "foo * bar" should be "foo *bar"
#1385: FILE: proc/base.c:1385:
+static int proc_pid_readlink(struct dentry * dentry, char __user * buffer, int buflen)

ERROR: space required before the open parenthesis '('
#1424: FILE: proc/base.c:1424:
+	if(dumpable == 1)

ERROR: "foo * bar" should be "foo *bar"
#1432: FILE: proc/base.c:1432:
+	struct inode * inode;

ERROR: "foo * bar" should be "foo *bar"
#1539: FILE: proc/base.c:1539:
+static int pid_delete_dentry(struct dentry * dentry)

ERROR: code indent should use tabs where possible
#1732: FILE: proc/base.c:1732:
+ ^Istruct inode *inode;$

ERROR: code indent should use tabs where possible
#1733: FILE: proc/base.c:1733:
+ ^Istruct proc_inode *ei;$

ERROR: "foo * bar" should be "foo *bar"
#1800: FILE: proc/base.c:1800:
+static int proc_readfd_common(struct file * filp, void * dirent,

ERROR: "foo * bar" should be "foo *bar"
#1808: FILE: proc/base.c:1808:
+	struct files_struct * files;

ERROR: switch and case should be at the same indent
#1816: FILE: proc/base.c:1816:
+	switch (fd) {
+		case 0:
[...]
+		case 1:
[...]
+		default:

ERROR: code indent should use tabs where possible
#1919: FILE: proc/base.c:1919:
+ ^Istruct inode *inode;$

ERROR: code indent should use tabs where possible
#1920: FILE: proc/base.c:1920:
+ ^Istruct proc_inode *ei;$

ERROR: trailing whitespace
#1997: FILE: proc/base.c:1997:
+static struct dentry *proc_pident_lookup(struct inode *dir, $

ERROR: "foo * bar" should be "foo *bar"
#2096: FILE: proc/base.c:2096:
+static ssize_t proc_pid_attr_read(struct file * file, char __user * buf,

ERROR: "foo * bar" should be "foo *bar"
#2099: FILE: proc/base.c:2099:
+	struct inode * inode = file->f_path.dentry->d_inode;

ERROR: "(foo*)" should be "(foo *)"
#2108: FILE: proc/base.c:2108:
+				      (char*)file->f_path.dentry->d_name.name,

ERROR: "foo * bar" should be "foo *bar"
#2117: FILE: proc/base.c:2117:
+static ssize_t proc_pid_attr_write(struct file * file, const char __user * buf,

ERROR: "foo * bar" should be "foo *bar"
#2120: FILE: proc/base.c:2120:
+	struct inode * inode = file->f_path.dentry->d_inode;

ERROR: "(foo*)" should be "(foo *)"
#2137: FILE: proc/base.c:2137:
+	page = (char*)__get_free_page(GFP_TEMPORARY);

ERROR: "(foo*)" should be "(foo *)"
#2146: FILE: proc/base.c:2146:
+				      (char*)file->f_path.dentry->d_name.name,

ERROR: "(foo*)" should be "(foo *)"
#2147: FILE: proc/base.c:2147:
+				      (void*)page, count);

ERROR: "foo * bar" should be "foo *bar"
#2170: FILE: proc/base.c:2170:
+static int proc_attr_dir_readdir(struct file * filp,

ERROR: "foo * bar" should be "foo *bar"
#2171: FILE: proc/base.c:2171:
+			     void * dirent, filldir_t filldir)

ERROR: space required after that ',' (ctx:VxV)
#2173: FILE: proc/base.c:2173:
+	return proc_pident_readdir(filp,dirent,filldir,
 	                               ^

ERROR: space required after that ',' (ctx:VxV)
#2173: FILE: proc/base.c:2173:
+	return proc_pident_readdir(filp,dirent,filldir,
 	                                      ^

ERROR: space required after that ',' (ctx:VxV)
#2174: FILE: proc/base.c:2174:
+				   attr_dir_stuff,ARRAY_SIZE(attr_dir_stuff));
 				                 ^

ERROR: "foo * bar" should be "foo *bar"
#2561: FILE: proc/base.c:2561:
+static int proc_tgid_base_readdir(struct file * filp,

ERROR: "foo * bar" should be "foo *bar"
#2562: FILE: proc/base.c:2562:
+			     void * dirent, filldir_t filldir)

ERROR: space required after that ',' (ctx:VxV)
#2564: FILE: proc/base.c:2564:
+	return proc_pident_readdir(filp,dirent,filldir,
 	                               ^

ERROR: space required after that ',' (ctx:VxV)
#2564: FILE: proc/base.c:2564:
+	return proc_pident_readdir(filp,dirent,filldir,
 	                                      ^

ERROR: space required after that ',' (ctx:VxV)
#2565: FILE: proc/base.c:2565:
+				   tgid_base_stuff,ARRAY_SIZE(tgid_base_stuff));
 				                  ^

ERROR: space required before the open brace '{'
#2573: FILE: proc/base.c:2573:
+static struct dentry *proc_tgid_base_lookup(struct inode *dir, struct dentry *dentry, struct nameidata *nd){

ERROR: "foo * bar" should be "foo *bar"
#2678: FILE: proc/base.c:2678:
+					   struct dentry * dentry,

ERROR: spaces required around that '|=' (ctx:VxV)
#2691: FILE: proc/base.c:2691:
+	inode->i_flags|=S_IMMUTABLE;
 	              ^

ERROR: "foo * bar" should be "foo *bar"
#2791: FILE: proc/base.c:2791:
+int proc_pid_readdir(struct file * filp, void * dirent, filldir_t filldir)

ERROR: "foo * bar" should be "foo *bar"
#2896: FILE: proc/base.c:2896:
+static int proc_tid_base_readdir(struct file * filp,

ERROR: "foo * bar" should be "foo *bar"
#2897: FILE: proc/base.c:2897:
+			     void * dirent, filldir_t filldir)

ERROR: space required after that ',' (ctx:VxV)
#2899: FILE: proc/base.c:2899:
+	return proc_pident_readdir(filp,dirent,filldir,
 	                               ^

ERROR: space required after that ',' (ctx:VxV)
#2899: FILE: proc/base.c:2899:
+	return proc_pident_readdir(filp,dirent,filldir,
 	                                      ^

ERROR: space required after that ',' (ctx:VxV)
#2900: FILE: proc/base.c:2900:
+				   tid_base_stuff,ARRAY_SIZE(tid_base_stuff));
 				                 ^

ERROR: space required before the open brace '{'
#2903: FILE: proc/base.c:2903:
+static struct dentry *proc_tid_base_lookup(struct inode *dir, struct dentry *dentry, struct nameidata *nd){

ERROR: spaces required around that '|=' (ctx:VxV)
#2931: FILE: proc/base.c:2931:
+	inode->i_flags|=S_IMMUTABLE;
 	              ^

ERROR: "foo * bar" should be "foo *bar"
#3060: FILE: proc/base.c:3060:
+static int proc_task_readdir(struct file * filp, void * dirent, filldir_t filldir)

total: 85 errors, 39 warnings, 2 checks, 3147 lines checked

fs/proc/base.c has style problems, please review.  If any of these errors
are false positives report them to the maintainer, see
CHECKPATCH in MAINTAINERS.
