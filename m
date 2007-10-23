Return-Path: <linux-kernel-owner+w=401wt.eu-S1753436AbXJWJxp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753436AbXJWJxp (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Oct 2007 05:53:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751687AbXJWJxh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 23 Oct 2007 05:53:37 -0400
Received: from static-71-162-243-5.phlapa.fios.verizon.net ([71.162.243.5]:53543
	"EHLO grelber.thyrsus.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751809AbXJWJxg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Oct 2007 05:53:36 -0400
From: Rob Landley <rob@landley.net>
Organization: Boundaries Unlimited
To: linux-kernel@vger.kernel.org
Subject: [PATCH 3/7] Add section IDs to mtdnand.tmpl
Date: Tue, 23 Oct 2007 04:53:03 -0500
User-Agent: KMail/1.9.6
Cc: akpm@linux-foundation.org, tglx@linutronix.de
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200710230453.03281.rob@landley.net>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Rob Landley <rob@landley.net>

Add section IDs to mtdnand.tmpl

Signed-off-by: Rob Landley <rob@landley.net>
---

 Documentation/DocBook/mtdnand.tmpl |   58 +++++++++++++--------------
 1 file changed, 29 insertions(+), 29 deletions(-)

diff -r a868e8217782 Documentation/DocBook/mtdnand.tmpl
--- a/Documentation/DocBook/mtdnand.tmpl	Mon Oct 22 19:40:02 2007 -0700
+++ b/Documentation/DocBook/mtdnand.tmpl	Tue Oct 23 04:39:50 2007 -0500
@@ -80,7 +80,7 @@
      struct member has a short description which is marked with an [XXX] identifier.
      The following chapters explain the meaning of those identifiers.
      </para>
-     <sect1>   
+     <sect1 id="Function_identifiers_XXX">   
 	<title>Function identifiers [XXX]</title>
      	<para>
 	The functions are marked with [XXX] identifiers in the short
@@ -115,7 +115,7 @@
 		</para></listitem>
 	</itemizedlist>
      </sect1>
-     <sect1>   
+     <sect1 id="Struct_member_identifiers_XXX">   
 	<title>Struct member identifiers [XXX]</title>
      	<para>
 	The struct members are marked with [XXX] identifiers in the 
@@ -159,7 +159,7 @@
 		basic functions and fill out some really board dependent
 		members in the nand chip description structure.
 	</para>
-	<sect1>
+	<sect1 id="Basic_defines">
 		<title>Basic defines</title>
 		<para>
 			At least you have to provide a mtd structure and
@@ -185,7 +185,7 @@ static unsigned long baseaddr;
 static unsigned long baseaddr;
 		</programlisting>
 	</sect1>
-	<sect1>
+	<sect1 id="Partition_defines">
 		<title>Partition defines</title>
 		<para>
 			If you want to divide your device into partitions, then
@@ -204,7 +204,7 @@ static struct mtd_partition partition_in
 };
 		</programlisting>
 	</sect1>
-	<sect1>
+	<sect1 id="Hardware_control_functions">
 		<title>Hardware control function</title>
 		<para>
 			The hardware control function provides access to the 
@@ -246,7 +246,7 @@ static void board_hwcontrol(struct mtd_i
 }
 		</programlisting>
 	</sect1>
-	<sect1>
+	<sect1 id="Device_ready_function">
 		<title>Device ready function</title>
 		<para>
 			If the hardware interface has the ready busy pin of the NAND chip connected to a
@@ -257,7 +257,7 @@ static void board_hwcontrol(struct mtd_i
 			the function must not be defined and the function pointer this->dev_ready is set to NULL.		
 		</para>
 	</sect1>
-	<sect1>
+	<sect1 id="Init_function">
 		<title>Init function</title>
 		<para>
 			The init function allocates memory and sets up all the board
@@ -325,7 +325,7 @@ module_init(board_init);
 module_init(board_init);
 		</programlisting>
 	</sect1>
-	<sect1>
+	<sect1 id="Exit_function">
 		<title>Exit function</title>
 		<para>
 			The exit function is only neccecary if the driver is
@@ -359,7 +359,7 @@ module_exit(board_cleanup);
 		driver. For a list of functions which can be overridden by the board
 		driver see the documentation of the nand_chip structure.
 	</para>
-	<sect1>
+	<sect1 id="Multiple_chip_control">
 		<title>Multiple chip control</title>
 		<para>
 			The nand driver can control chip arrays. Therefor the
@@ -419,9 +419,9 @@ static void board_select_chip (struct mt
 }
 		</programlisting>
 	</sect1>
-	<sect1>
+	<sect1 id="Hardware_ECC_support">
 		<title>Hardware ECC support</title>
-		<sect2>
+		<sect2 id="Functions_and_constants">
 			<title>Functions and constants</title>
 			<para>
 				The nand driver supports three different types of
@@ -475,7 +475,7 @@ static void board_select_chip (struct mt
 				</itemizedlist>
 			</para>
 		</sect2>
-		<sect2>
+		<sect2 id="Hardware_ECC_with_syndrome_calculation">
 		<title>Hardware ECC with syndrome calculation</title>
 			<para>
 				Many hardware ECC implementations provide Reed-Solomon
@@ -500,7 +500,7 @@ static void board_select_chip (struct mt
 			</para>
 		</sect2>
 	</sect1>
-	<sect1>
+	<sect1 id="Bad_Block_table_support">
 		<title>Bad block table support</title>
 		<para>
 			Most NAND chips mark the bad blocks at a defined
@@ -552,7 +552,7 @@ static void board_select_chip (struct mt
 			allows faster access than always checking the
 			bad block information on the flash chip itself.
 		</para>
-		<sect2>
+		<sect2 id="Flash_based_tables">
 			<title>Flash based tables</title>
 			<para>
 				It may be desired or neccecary to keep a bad block table in FLASH. 
@@ -587,7 +587,7 @@ static void board_select_chip (struct mt
 				</itemizedlist>
 			</para>
 		</sect2>
-		<sect2>
+		<sect2 id="User_defined_tables">
 			<title>User defined tables</title>
 			<para>
 				User defined tables are created by filling out a 
@@ -676,7 +676,7 @@ static void board_select_chip (struct mt
 			</para>
 		</sect2>
 	</sect1>
-	<sect1>
+	<sect1 id="Spare_area_placement">
 		<title>Spare area (auto)placement</title>
 		<para>
 			The nand driver implements different possibilities for
@@ -730,7 +730,7 @@ struct nand_oobinfo {
 			</para></listitem>
 			</itemizedlist>
 		</para>
-		<sect2>
+		<sect2 id="Placement_defined_by_fs_driver">
 			<title>Placement defined by fs driver</title>
 			<para>
 				The calling function provides a pointer to a nand_oobinfo
@@ -760,7 +760,7 @@ struct nand_oobinfo {
 				done according to the given scheme in the nand_oobinfo structure.
 			</para>
 		</sect2>
-		<sect2>
+		<sect2 id="Automatic_placement">
 			<title>Automatic placement</title>
 			<para>
 				Automatic placement uses the built in defaults to place the
@@ -774,7 +774,7 @@ struct nand_oobinfo {
 				done according to the default builtin scheme.
 			</para>
 		</sect2>
-		<sect2>
+		<sect2 id="User_space_placement_selection">
 			<title>User space placement selection</title>
 		<para>
 			All non ecc functions like mtd->read and mtd->write use an internal 
@@ -789,9 +789,9 @@ struct nand_oobinfo {
 		</para>
 		</sect2>
 	</sect1>	
-	<sect1>
+	<sect1 id="Spare_area_autoplacement_default">
 		<title>Spare area autoplacement default schemes</title>
-		<sect2>
+		<sect2 id="pagesize_256">
 			<title>256 byte pagesize</title>
 <informaltable><tgroup cols="3"><tbody>
 <row>
@@ -843,7 +843,7 @@ pages this byte is reserved</entry>
 </row>
 </tbody></tgroup></informaltable>
 		</sect2>
-		<sect2>
+		<sect2 id="pagesize_512">
 			<title>512 byte pagesize</title>
 <informaltable><tgroup cols="3"><tbody>
 <row>
@@ -906,7 +906,7 @@ in this page</entry>
 </row>
 </tbody></tgroup></informaltable>
 		</sect2>
-		<sect2>
+		<sect2 id="pagesize_2048">
 			<title>2048 byte pagesize</title>
 <informaltable><tgroup cols="3"><tbody>
 <row>
@@ -1126,9 +1126,9 @@ in this page</entry>
      <para>
      This chapter describes the constants which might be relevant for a driver developer.
      </para>
-     <sect1>   
+     <sect1 id="Chip_option_constants">   
 	<title>Chip option constants</title>
-     	<sect2>   
+     	<sect2 id="Constants_for_chip_id_table">
 		<title>Constants for chip id table</title>
      		<para>
 		These constants are defined in nand.h. They are ored together to describe
@@ -1153,7 +1153,7 @@ in this page</entry>
 		</programlisting>
      		</para>
      	</sect2>
-     	<sect2>   
+     	<sect2 id="Constants_for_runtime_options">   
 		<title>Constants for runtime options</title>
      		<para>
 		These constants are defined in nand.h. They are ored together to describe
@@ -1171,7 +1171,7 @@ in this page</entry>
      	</sect2>
      </sect1>	
 
-     <sect1>   
+     <sect1 id="EEC_selection_constants">   
 	<title>ECC selection constants</title>
 	<para>
 	Use these constants to select the ECC algorithm.
@@ -1192,7 +1192,7 @@ in this page</entry>
 	</para>
      </sect1>	
 
-     <sect1>   
+     <sect1 id="Hardware_control_related_constants">   
 	<title>Hardware control related constants</title>
 	<para>
 	These constants describe the requested hardware access function when
@@ -1218,7 +1218,7 @@ in this page</entry>
 	</para>
      </sect1>	
 
-     <sect1>   
+     <sect1 id="Bad_block_table_constants">   
 	<title>Bad block table related constants</title>
 	<para>
 	These constants describe the options used for bad block

-- 
"One of my most productive days was throwing away 1000 lines of code."
  - Ken Thompson.
